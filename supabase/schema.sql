-- GIFT Excellence — banco exclusivo do sistema financeiro
-- Execute este arquivo inteiro no SQL Editor do Supabase.

create schema if not exists gift_financeiro;

grant usage on schema gift_financeiro to authenticated, service_role;
revoke all on schema gift_financeiro from anon;

create table if not exists gift_financeiro.app_state (
  id text primary key,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid default auth.uid()
);

comment on table gift_financeiro.app_state is
  'Estado único e isolado do sistema financeiro GIFT Excellence.';

alter table gift_financeiro.app_state enable row level security;

drop policy if exists "gift_authenticated_read" on gift_financeiro.app_state;
create policy "gift_authenticated_read"
on gift_financeiro.app_state
for select
to authenticated
using (true);

drop policy if exists "gift_authenticated_insert" on gift_financeiro.app_state;
create policy "gift_authenticated_insert"
on gift_financeiro.app_state
for insert
to authenticated
with check (auth.uid() is not null);

drop policy if exists "gift_authenticated_update" on gift_financeiro.app_state;
create policy "gift_authenticated_update"
on gift_financeiro.app_state
for update
to authenticated
using (auth.uid() is not null)
with check (auth.uid() is not null);

drop policy if exists "gift_authenticated_delete" on gift_financeiro.app_state;
create policy "gift_authenticated_delete"
on gift_financeiro.app_state
for delete
to authenticated
using (auth.uid() is not null);

grant select, insert, update, delete on gift_financeiro.app_state to authenticated;
grant all on gift_financeiro.app_state to service_role;

create or replace function gift_financeiro.set_updated_metadata()
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

drop trigger if exists trg_gift_app_state_updated on gift_financeiro.app_state;
create trigger trg_gift_app_state_updated
before update on gift_financeiro.app_state
for each row execute function gift_financeiro.set_updated_metadata();
