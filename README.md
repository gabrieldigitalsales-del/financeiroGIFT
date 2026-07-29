# GIFT Financeiro — React/Vite + Supabase + Vercel

Sistema financeiro da GIFT Excellence com layout fiel à matriz Base44, banco centralizado e isolado em um schema próprio do Supabase.

## Estrutura do banco

O projeto usa o tabela exclusiva `public_app_state` no schema `public` e a tabela `app_state`. Dessa forma, os dados deste sistema não se misturam com tabelas de outros projetos no mesmo Supabase.

## 1. Criar/configurar o Supabase

1. Crie um projeto Supabase exclusivo para a GIFT (recomendado).
2. Abra **SQL Editor**.
3. Execute todo o conteúdo de `supabase/schema.sql`.
4. Em **API Settings → Exposed schemas**, adicione `public`.
5. Em **Authentication → Users**, crie o primeiro usuário com e-mail e senha.

O banco usa RLS e só permite leitura/escrita a usuários autenticados.

## 2. Variáveis locais

Copie `.env.example` para `.env.local` e preencha:

```env
VITE_SUPABASE_URL=https://SEU-PROJETO.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sua_chave_publicavel
```

Nunca coloque a `service_role` no navegador ou na Vercel.

## 3. Rodar no computador

```bash
npm install
npm run dev
```

Ou execute `start.bat` no Windows.

## 4. Publicar na Vercel

- Framework: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Install command: `npm install`

Na Vercel, adicione as mesmas duas variáveis em **Settings → Environment Variables**.

## Primeira inicialização

Após o primeiro login, se o banco estiver vazio, o sistema importa automaticamente `public/data/initialData.json` e grava a matriz no Supabase. Depois disso, todos os dispositivos autenticados usam a mesma base.

## Segurança

- Schema exclusivo: `public`
- Acesso anônimo bloqueado
- RLS habilitado
- Apenas usuários autenticados podem consultar ou alterar dados
- Chave secreta/service role não é usada no frontend


## Correção do erro Invalid schema
Esta edição não usa schema personalizado. O Supabase é acessado pelo schema `public`, e o banco da GIFT fica isolado pelo nome exclusivo da tabela `gift_financeiro_app_state`. Assim não é necessário configurar “Exposed schemas”.
