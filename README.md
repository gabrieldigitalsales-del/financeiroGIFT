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

## Leitura de boleto por imagem
Na tela **Boletos**, clique em **Novo Boleto** e depois em **Selecionar imagem**. Em celulares, o seletor pode abrir a câmera. O sistema tenta primeiro a leitura nativa do código de barras e, quando necessário, usa OCR local com Tesseract.js. Código, valor e vencimento devem ser conferidos antes de salvar.

## Tipografia
Todo o sistema usa a pilha nativa `system-ui`, com Segoe UI no Windows, San Francisco em dispositivos Apple e Roboto/Arial como fallback. Nenhuma fonte externa é carregada.

## Leitura de boletos
A tela Boletos aceita linha digitável manual, imagens JPG/PNG/WEBP, câmera do celular e PDF. O sistema tenta localizar o código de barras/linha digitável, valor, vencimento e competência. A conferência manual antes de salvar continua obrigatória.

Na projeção, o campo **Saldo disponível no início da projeção** corresponde ao dinheiro já disponível em caixa e contas bancárias no primeiro dia projetado. Valores ainda a receber não devem ser incluídos.

## Leitura segura de boletos

A importação de boletos segue esta ordem:

1. PDF com texto: procura uma linha digitável de 47 ou 48 dígitos e valida os dígitos verificadores.
2. PDF escaneado ou imagem: tenta ler o código de barras; OCR é usado apenas como alternativa.
3. Valor e vencimento são extraídos da estrutura validada do código. O sistema não procura números aleatórios na imagem para preencher esses campos.
4. Se o código não for validado, valor e vencimento não são preenchidos automaticamente.
5. Código colado manualmente também é validado ao sair do campo.

Teste de referência incluído na implementação:
- Linha: `00190.62827 84776.433207 00002.062313 3 15090000350063`
- Valor esperado: `R$ 3.500,63`
- Vencimento esperado: `16/07/2026`

## Leitura validada de boletos

A leitura agora prioriza a linha digitável/código de barras validado. PDFs com texto são lidos sem OCR; em PDF escaneado ou imagem, o sistema tenta o código e só depois usa OCR. Valor e vencimento são extraídos da estrutura do código validado. Se os dígitos verificadores falharem, o sistema não preenche esses dados automaticamente.

Referência de teste:
- Linha: `00190.62827 84776.433207 00002.062313 3 15090000350063`
- Valor: `R$ 3.500,63`
- Vencimento: `16/07/2026`

## Layout final aprovado

Esta versão replica a referência visual aprovada em `docs/layout-referencia-aprovada.png`:

- logo fixa no canto superior esquerdo;
- menu superior horizontal sem quebra de linha;
- rolagem lateral somente na área central do menu;
- ações do usuário fixas à direita;
- fonte nativa System UI / Segoe UI;
- cartões em gradiente com ícone à esquerda e textura suave;
- tabelas, filtros, badges, progresso e paginação no mesmo padrão visual;
- aplicação do padrão em todas as telas.

Nenhuma alteração no schema SQL é necessária para esta atualização visual.
