# Módulo 3 — Banco de Dados e Controle de versão

Complemento do projeto **Solicita Comunidade**.

## Banco de dados
SGBD adotado: **SQLite 3**.

O `database.sql` contém criação de tabelas, chaves primárias e estrangeiras, restrições, índices, inserção de dados e exemplos de `INSERT`, `UPDATE`, `SELECT` e `DELETE`.

## Modelo
- categorias 1:N solicitacoes
- status 1:N solicitacoes
- solicitacoes 1:N historico_status
- status 1:N historico_status

## Execução
```bash
sqlite3 solicita_comunidade.db < database.sql
```

## Relação com o Módulo 2
A interface web continua demonstrando o fluxo com Vue.js e LocalStorage. Neste módulo, o banco relacional representa a camada persistente estruturada para a evolução da aplicação.

## Repositório
https://github.com/ailtondebrito6-lgtm/solicita-comunidade-ufms
