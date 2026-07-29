import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;
export const supabaseConfigured = Boolean(url && key);

export const supabase = supabaseConfigured
  ? createClient(url, key, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true },
    })
  : null;

const ROW_ID = 'matriz-principal';

export async function loadAppState() {
  const { data, error } = await supabase
    .from('gift_financeiro_app_state')
    .select('payload, updated_at')
    .eq('id', ROW_ID)
    .maybeSingle();
  if (error) throw error;
  return data?.payload ?? null;
}

export async function seedAppState(payload) {
  const { error } = await supabase.from('gift_financeiro_app_state').insert({ id: ROW_ID, payload });
  if (error && error.code !== '23505') throw error;
  if (error?.code === '23505') return loadAppState();
  return payload;
}

export async function saveAppState(payload) {
  const { error } = await supabase
    .from('gift_financeiro_app_state')
    .upsert({ id: ROW_ID, payload, updated_at: new Date().toISOString() }, { onConflict: 'id' });
  if (error) throw error;
}
