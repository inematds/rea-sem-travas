# 1. Instalar o REA e preparar a análise

Cole no painel do dsh (`http://127.0.0.1:9080`), com o workspace apontando para a pasta
onde está o alvo (ex.: `/work/alvos` ou `/projetos/<sua-pasta>`).

## Caminho A — app Electron/JavaScript (sem Ghidra, já medido nesta máquina)

```text
Instale isto e me ajude a fazer engenharia reversa de um app: https://github.com/morluto/rea

Regras:
- Não instale nada global. Use npx: `npx -y rea-agents@6.4.0 <comando>`.
- Rode SEMPRE com teto de tempo: `timeout -k 10 600 npx -y rea-agents@6.4.0 ...`.
  Se estourar (código 124 ou 137), me avise; não tente de novo sem eu pedir.
- Primeiro rode `npx -y rea-agents@6.4.0 --help` e me mostre os comandos de análise.
- Depois analise o app em <CAMINHO ABSOLUTO DO app.asar OU DA PASTA DO APP> com
  `analyze-javascript-application <caminho> --json > /work/alvos/rea-analise.json`.
- Resuma: módulos principais, telas, onde fica a função <FUNÇÃO QUE ME INTERESSA>,
  o que roda no servidor (e portanto não dá para recriar) e o que ficou desconhecido.
- Mostre a evidência (arquivo e trecho) de cada conclusão.
```

## Caminho B — via MCP (com o REA registrado no dsh; não medido aqui)

```text
Você tem as ferramentas mcp__rea__*. Use-as para entender o app <NOME DO APP>
em <CAMINHO ABSOLUTO>. Comece pelo inventário (o que é o binário, que motor de análise
está disponível) e me diga o que conseguiu ver e o que não conseguiu, antes de escrever
qualquer código.
```
