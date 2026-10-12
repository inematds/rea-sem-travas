# REA sem travas

[![Seu agente sem travas](guia/assets/banner.jpg)](https://inematds.github.io/rea-sem-travas/guia/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## O que é

Este é um guia em português para recriar um programa de computador do seu jeito usando três peças abertas: um harness de agente local (o **dsh**, agente de código da DeepSeek), um **modelo aberto "sem trava"** rodando no Ollama e o **REA**, que dá ao agente ferramentas de engenharia reversa como o Ghidra. Serve para quem programa ou estuda e quer entender como um app funciona e fazer a própria versão, sem depender de modelos de nuvem que às vezes recusam o pedido. Tudo roda na sua máquina: você precisa de Docker, Ollama, Node 22 e memória para um modelo de 14 a 24 GB. Espere chegar a uns 80% do app, não à última milha.

## 📖 Guia de uso

Guia completo (landing + passo a passo): **https://inematds.github.io/rea-sem-travas/guia/**

## 🎬 Assista ao vídeo

**https://inematds.github.io/rea-sem-travas/videos/**

## As três peças

| Peça | Papel | Onde |
|---|---|---|
| **dsh** (`@deepseek-ai/dsh`) | Harness: o corpo do agente (arquivos, comandos, MCP), em container e só em `127.0.0.1:9080` | `~/projetos/dsh-sandbox` (`./dsh local`) |
| **Modelo sem trava** | O cérebro: modelo aberto "abliterated", sem o reflexo de recusar | Ollama local, porta 11434 |
| **REA** ([morluto/rea](https://github.com/morluto/rea), MIT, ~147 mil estrelas em 12/10/2026) | Os olhos: MCP + CLI de engenharia reversa (Ghidra, Hopper, IDA, análise de JS/Electron) | `npx -y rea-agents@6.4.0` |

## Modelos sem trava conferidos (página do Ollama, 12/10/2026)

Nenhum foi baixado nem medido nesta máquina (disco em 98%). Confira a etiqueta **tools** na página: sem ela o agente não chama o REA.

| Comando exato | Tamanho | Recursos na página |
|---|---|---|
| `ollama pull huihui_ai/Qwen3.8-abliterated:27b` | 18 GB | tools · thinking · vision |
| `ollama pull huihui_ai/Qwen3.6-abliterated:35b-a3b` | 24 GB | tools · thinking · vision |
| `ollama pull huihui_ai/glm-4.7-flash-abliterated` | 19 GB | tools · thinking |
| `ollama pull huihui_ai/gpt-oss-abliterated:20b` | 14 GB | tools · thinking |
| `ollama pull huihui_ai/qwen3-coder-abliterated:30b` | 19 GB | sem etiqueta "tools" |

Sem máquina para isso: há serviços de nuvem pré-pagos de terceiros, no estilo do OpenRouter (que o dsh aceita no `./dsh remoto`), que hospedam modelos sem trava com crédito de US$ 5 a 10. Aí o código sai da sua máquina.

## Passo a passo (resumo)

1. **Suba o harness:** `cd ~/projetos/dsh-sandbox && ./dsh local`, abra `http://127.0.0.1:9080`.
2. **Modelo:** `ollama pull huihui_ai/Qwen3.8-abliterated:27b`, acrescente o `id` em `settings.local.yaml` (com `reasoningEfforts.off: none`) e rode `./dsh local` de novo.
3. **REA:** caminho A (medido): o agente roda `npx -y rea-agents@6.4.0 analyze-javascript-application <app> --json` com `timeout`. Caminho B (não medido): REA como MCP via `cordis.patch.yml`. Binário nativo pede Ghidra 12.1.x + JDK 21.
4. **Alvo:** peça um app **novo**, com nome e ícone seus, que faça o que falta no original.
5. **Itere:** um ajuste por vez, testando entre eles.

Prompts para copiar e colar: [`prompts/`](prompts/). Teto de tempo/memória para o REA: [`scripts/rea-com-timeout.sh`](scripts/rea-com-timeout.sh).

## Números do vídeo de referência (não medidos aqui)

App de vídeo do Mac refeito com outro nome e velocidade granular: ~80% num pedido só, 1ª versão em 20 a 30 min por US$ 4, mais US$ 5 a 6 em ajustes, com modelo na nuvem. Local, o custo por pedido é zero; fica a máquina.

## Limites

- O que mora no servidor do fabricante não vem (ex.: a biblioteca SmartArt do PowerPoint).
- Chega a ~80%, não à última milha.
- Modelos de fronteira (Claude, Codex, Gemini) às vezes recusam partes e podem fechar a porta; por isso o modelo local.

## Uso responsável

"Sem trava" significa o modelo não recusar tarefas **legítimas** de engenharia reversa; não é para nada ilegal.

- Use em programa que você tem e usa, para interoperabilidade e uso próprio.
- Escreva do zero, com nome, ícone e visual seus. Não redistribua código, ícones, textos ou marcas do fabricante.
- Vender cópia esbarra em direito autoral e licença. Não quebre proteção contra cópia, licença ou DRM.
- O REA não é sandbox: binário desconhecido só em máquina isolada.

## O que foi medido e o que não foi

| Item | Status |
|---|---|
| dsh local + Ollama (`qwen3.8:27b`) | medido (dsh-sandbox, 08/2026) |
| REA, análise JS sem Ghidra | medido: 6.3.0 em 20 s (97 arquivos); 6.4.0 em 94,5 s (202 arquivos JS, pico 1,26 GB) |
| REA 6.3.0 travando em JS gigante / `rea-com-timeout.sh` | medido |
| Modelos sem trava da tabela | não medido |
| REA como MCP dentro do dsh | não medido |
| Ghidra nesta máquina (só JDK 8) | não medido |
| Clone do QuickTime, custos e tempos do vídeo | não medido |

## Veja também

- Guia anterior, com a técnica e os casos: [inematds/rea-engenharia-reversa](https://inematds.github.io/rea-engenharia-reversa/guia/)
- REA: [github.com/morluto/rea](https://github.com/morluto/rea) · [rea.tools](https://rea.tools/)

## Licença

MIT. Conteúdo aberto e gratuito do **[INEMA.CLUB](https://inema.club)**.
