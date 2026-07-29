# GIFT Financeiro Premium — React + Vite

Sistema reconstruído a partir da matriz Base44, respeitando as tabelas, status, mês/ano de referência e regras documentadas.

## Executar no Windows
1. Extraia a pasta.
2. Execute `start.bat`.
3. Aguarde abrir no navegador.

## Regras importantes
- DRE, Fluxo, Margem e análises usam `mes_referencia` / `ano_referencia`.
- Realizados: status `pago` ou `recebido`.
- Pendentes não entram no realizado.
- Cancelados só aparecem no Ciclo Financeiro.
- Boletos criam um lançamento vinculado e não são somados em duplicidade.
- Projeções ficam separadas dos relatórios oficiais.
- Exportações de Análise de Custos e Análise de Despesas foram alinhadas às respectivas telas.

Os dados são salvos localmente no navegador. Use “Restaurar base” para voltar aos dados iniciais.
