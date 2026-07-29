-- GIFT Excellence — banco isolado no schema public
-- Esta versão evita o erro "Invalid schema: gift_financeiro".
-- O isolamento é feito pelo prefixo exclusivo gift_financeiro_.

create table if not exists public.gift_financeiro_app_state (
  id text primary key,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid default auth.uid()
);

comment on table public.gift_financeiro_app_state is
  'Estado único e isolado do sistema financeiro GIFT Excellence.';

alter table public.gift_financeiro_app_state enable row level security;

drop policy if exists "gift_authenticated_read" on public.gift_financeiro_app_state;
create policy "gift_authenticated_read"
on public.gift_financeiro_app_state
for select
to authenticated
using (true);

drop policy if exists "gift_authenticated_insert" on public.gift_financeiro_app_state;
create policy "gift_authenticated_insert"
on public.gift_financeiro_app_state
for insert
to authenticated
with check (auth.uid() is not null);

drop policy if exists "gift_authenticated_update" on public.gift_financeiro_app_state;
create policy "gift_authenticated_update"
on public.gift_financeiro_app_state
for update
to authenticated
using (auth.uid() is not null)
with check (auth.uid() is not null);

drop policy if exists "gift_authenticated_delete" on public.gift_financeiro_app_state;
create policy "gift_authenticated_delete"
on public.gift_financeiro_app_state
for delete
to authenticated
using (auth.uid() is not null);

grant select, insert, update, delete on public.gift_financeiro_app_state to authenticated;
grant all on public.gift_financeiro_app_state to service_role;

create or replace function public.gift_financeiro_set_updated_metadata()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  new.updated_by = auth.uid();
  return new;
end;
$$;

drop trigger if exists trg_gift_app_state_updated on public.gift_financeiro_app_state;
create trigger trg_gift_app_state_updated
before update on public.gift_financeiro_app_state
for each row execute function public.gift_financeiro_set_updated_metadata();

-- Opcional: migra um estado antigo caso o schema personalizado exista.
do $$
begin
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'gift_financeiro' and table_name = 'app_state'
  ) then
    execute 'insert into public.gift_financeiro_app_state (id,payload,updated_at,updated_by)
             select id,payload,updated_at,updated_by from gift_financeiro.app_state
             on conflict (id) do update set payload=excluded.payload, updated_at=excluded.updated_at, updated_by=excluded.updated_by';
  end if;
end $$;

notify pgrst, 'reload schema';
