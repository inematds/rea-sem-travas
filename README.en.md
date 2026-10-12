# REA without restrictions

[![Your unrestricted agent](guia/assets/banner-en.jpg)](https://inematds.github.io/rea-sem-travas/guia/en/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## What it is

This is a guide for recreating a computer program your way using three open components: a local agent harness (the **dsh**, DeepSeek’s coding agent), an **open “uncensored” model** running in Ollama, and **REA**, which gives the agent reverse engineering tools such as Ghidra. It’s for people who code or study and want to understand how an app works and make their own version without relying on cloud models that sometimes refuse the request. Everything runs on your machine: you need Docker, Ollama, Node 22, and enough memory for a 14 to 24 GB model. Expect to get to about 80% of the app, not the final mile.

## 📖 Usage guide

Complete guide (landing page + walkthrough): **https://inematds.github.io/rea-sem-travas/guia/en/**

## 🎬 Watch the video

**https://inematds.github.io/rea-sem-travas/videos/**

## The three components

| Component | Role | Where |
|---|---|---|
| **dsh** (`@deepseek-ai/dsh`) | Harness: the agent’s body (files, commands, MCP), in a container and only on `127.0.0.1:9080` | `~/projetos/dsh-sandbox` (`./dsh local`) |
| **Uncensored model** | The brain: an open “abliterated” model without the reflex to refuse | Local Ollama, port 11434 |
| **REA** ([morluto/rea](https://github.com/morluto/rea), MIT, ~147 thousand stars as of 10/12/2026) | The eyes: MCP + reverse engineering CLI (Ghidra, Hopper, IDA, JS/Electron analysis) | `npx -y rea-agents@6.4.0` |

## Uncensored models checked (Ollama page, 10/12/2026)

None were downloaded or benchmarked on this machine (disk at 98%). Check the **tools** label on the page: without it, the agent can’t call REA.

| Exact command | Size | Features on the page |
|---|---|---|
| `ollama pull huihui_ai/Qwen3.8-abliterated:27b` | 18 GB | tools · thinking · vision |
| `ollama pull huihui_ai/Qwen3.6-abliterated:35b-a3b` | 24 GB | tools · thinking · vision |
| `ollama pull huihui_ai/glm-4.7-flash-abliterated` | 19 GB | tools · thinking |
| `ollama pull huihui_ai/gpt-oss-abliterated:20b` | 14 GB | tools · thinking |
| `ollama pull huihui_ai/qwen3-coder-abliterated:30b` | 19 GB | no “tools” label |

No machine available for this: there are prepaid third-party cloud services, similar to OpenRouter (which dsh supports with `./dsh remoto`), that host uncensored models with US$ 5 to 10 in credits. In that case, the code leaves your machine.

## Step by step (summary)

1. **Start the harness:** `cd ~/projetos/dsh-sandbox && ./dsh local`, open `http://127.0.0.1:9080`.
2. **Model:** `ollama pull huihui_ai/Qwen3.8-abliterated:27b`, add the `id` to `settings.local.yaml` (with `reasoningEfforts.off: none`) and run `./dsh local` again.
3. **REA:** path A (measured): the agent runs `npx -y rea-agents@6.4.0 analyze-javascript-application <app> --json` with `timeout`. Path B (not measured): REA as MCP via `cordis.patch.yml`. Native binary requires Ghidra 12.1.x + JDK 21.
4. **Target:** ask for a **new** app, with your own name and icon, that does what’s missing from the original.
5. **Iterate:** one adjustment at a time, testing between them.

Prompts to copy and paste: [`prompts/`](prompts/). Time/memory limit for REA: [`scripts/rea-com-timeout.sh`](scripts/rea-com-timeout.sh).

## Numbers from the reference video (not measured here)

Mac video app recreated with another name and granular speed control: ~80% in one request, first version in 20 to 30 minutes for US$ 4, plus another US$ 5 to 6 in adjustments, using a cloud model. Locally, the cost per request is zero; the machine does the work.

## Limits

- What lives on the manufacturer’s server isn’t included (e.g., PowerPoint’s SmartArt library).
- It gets to ~80%, not the final mile.
- Frontier models (Claude, Codex, Gemini) sometimes refuse parts of the task and may shut the door; that’s why the local model.

## Responsible use

“Uncensored” means the model doesn’t refuse **legitimate** reverse engineering tasks; it’s not for anything illegal.

- Use it with a program you own and use, for interoperability and personal use.
- Write it from scratch, with your own name, icon, and look. Don’t redistribute the manufacturer’s code, icons, text, or trademarks.
- Selling a copy runs into copyright and licensing issues. Don’t bypass copy protection, licenses, or DRM.
- REA is not a sandbox: run unknown binaries only on an isolated machine.

## What was measured and what wasn’t

| Item | Status |
|---|---|
| dsh local + Ollama (`qwen3.8:27b`) | measured (dsh-sandbox, 08/2026) |
| REA, JS analysis without Ghidra | measured: 6.3.0 in 20 s (97 files); 6.4.0 in 94.5 s (202 JS files, 1.26 GB peak) |
| REA 6.3.0 hanging on huge JS / `rea-com-timeout.sh` | measured |
| Uncensored models in the table | not measured |
| REA as MCP inside dsh | not measured |
| Ghidra on this machine (JDK 8 only) | not measured |
| QuickTime clone, costs, and times from the video | not measured |

## See also

- Previous guide, with the technique and examples: [inematds/rea-engenharia-reversa](https://inematds.github.io/rea-engenharia-reversa/guia/) (in Portuguese)
- REA: [github.com/morluto/rea](https://github.com/morluto/rea) · [rea.tools](https://rea.tools/)

## License

MIT. Open and free content from **[INEMA.CLUB](https://inema.club)**.