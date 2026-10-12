# REA sin trabas

[![Tu agente sin trabas](guia/assets/banner-es.jpg)](https://inematds.github.io/rea-sem-travas/guia/es/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## Qué es

Esta es una guía para recrear un programa de computadora a tu manera usando tres piezas abiertas: un harness de agente local (el **dsh**, agente de código de DeepSeek), un **modelo abierto «sin restricciones»** ejecutándose en Ollama y **REA**, que le da al agente herramientas de ingeniería inversa como Ghidra. Está dirigida a quienes programan o estudian y quieren entender cómo funciona una app y crear su propia versión, sin depender de modelos en la nube que a veces rechazan la solicitud. Todo se ejecuta en tu máquina: necesitas Docker, Ollama, Node 22 y memoria para un modelo de 14 a 24 GB. Espera llegar a cerca del 80% de la app, no a los últimos detalles.

## 📖 Guía de uso

Guía completa (landing + paso a paso): **https://inematds.github.io/rea-sem-travas/guia/es/**

## 🎬 Mira el video

**https://inematds.github.io/rea-sem-travas/videos/**

## Las tres piezas

| Pieza | Función | Dónde |
|---|---|---|
| **dsh** (`@deepseek-ai/dsh`) | Harness: el cuerpo del agente (archivos, comandos, MCP), en un contenedor y solo en `127.0.0.1:9080` | `~/projetos/dsh-sandbox` (`./dsh local`) |
| **Modelo sin restricciones** | El cerebro: modelo abierto «abliterated», sin el reflejo de rechazar | Ollama local, puerto 11434 |
| **REA** ([morluto/rea](https://github.com/morluto/rea), MIT, ~147 mil estrellas al 12/10/2026) | Los ojos: MCP + CLI de ingeniería inversa (Ghidra, Hopper, IDA, análisis de JS/Electron) | `npx -y rea-agents@6.4.0` |

## Modelos sin restricciones verificados (página de Ollama, 12/10/2026)

Ninguno se descargó ni se midió en esta máquina (disco al 98%). Revisa la etiqueta **tools** en la página: sin ella, el agente no llama a REA.

| Comando exacto | Tamaño | Recursos en la página |
|---|---|---|
| `ollama pull huihui_ai/Qwen3.8-abliterated:27b` | 18 GB | tools · thinking · vision |
| `ollama pull huihui_ai/Qwen3.6-abliterated:35b-a3b` | 24 GB | tools · thinking · vision |
| `ollama pull huihui_ai/glm-4.7-flash-abliterated` | 19 GB | tools · thinking |
| `ollama pull huihui_ai/gpt-oss-abliterated:20b` | 14 GB | tools · thinking |
| `ollama pull huihui_ai/qwen3-coder-abliterated:30b` | 19 GB | sin etiqueta «tools» |

Si no tienes una máquina adecuada: hay servicios en la nube prepagados de terceros, al estilo de OpenRouter (que dsh acepta con `./dsh remoto`), que alojan modelos sin restricciones con un crédito de US$ 5 a 10. En ese caso, el código sale de tu máquina.

## Paso a paso (resumen)

1. **Inicia el harness:** `cd ~/projetos/dsh-sandbox && ./dsh local`, abre `http://127.0.0.1:9080`.
2. **Modelo:** `ollama pull huihui_ai/Qwen3.8-abliterated:27b`, añade el `id` a `settings.local.yaml` (con `reasoningEfforts.off: none`) y ejecuta `./dsh local` de nuevo.
3. **REA:** camino A (medido): el agente ejecuta `npx -y rea-agents@6.4.0 analyze-javascript-application <app> --json` con `timeout`. Camino B (no medido): REA como MCP mediante `cordis.patch.yml`. El binario nativo requiere Ghidra 12.1.x + JDK 21.
4. **Objetivo:** pide una app **nueva**, con nombre e ícono propios, que haga lo que falta en la original.
5. **Itera:** un ajuste a la vez, probando entre ellos.

Prompts para copiar y pegar: [`prompts/`](prompts/). Límite de tiempo/memoria para REA: [`scripts/rea-com-timeout.sh`](scripts/rea-com-timeout.sh).

## Cifras del video de referencia (no medidas aquí)

App de video de Mac recreada con otro nombre y velocidad granular: ~80% en una sola solicitud, primera versión en 20 a 30 min por US$ 4, más US$ 5 a 6 en ajustes, con un modelo en la nube. En local, el costo por solicitud es cero; el costo es la máquina.

## Límites

- Lo que está en el servidor del fabricante no viene incluido (por ejemplo, la biblioteca SmartArt de PowerPoint).
- Llega a ~80%, no a los últimos detalles.
- Los modelos de frontera (Claude, Codex, Gemini) a veces rechazan algunas partes y pueden cerrar la puerta; por eso se usa el modelo local.

## Uso responsable

«Sin trabas» significa que el modelo no rechaza tareas **legítimas** de ingeniería inversa; no es para nada ilegal.

- Úsalo en un programa que tengas y utilices, para interoperabilidad y uso propio.
- Escribe desde cero, con nombre, ícono y aspecto propios. No redistribuyas código, íconos, textos ni marcas del fabricante.
- Vender una copia puede infringir derechos de autor y licencias. No eludas protecciones contra copia, licencias ni DRM.
- REA no es un sandbox: ejecuta binarios desconocidos solo en una máquina aislada.

## Qué se midió y qué no

| Elemento | Estado |
|---|---|
| dsh local + Ollama (`qwen3.8:27b`) | medido (dsh-sandbox, 08/2026) |
| REA, análisis JS sin Ghidra | medido: 6.3.0 en 20 s (97 archivos); 6.4.0 en 94,5 s (202 archivos JS, pico de 1,26 GB) |
| REA 6.3.0 bloqueándose con JS gigante / `rea-com-timeout.sh` | medido |
| Modelos sin restricciones de la tabla | no medido |
| REA como MCP dentro de dsh | no medido |
| Ghidra en esta máquina (solo JDK 8) | no medido |
| Clon de QuickTime, costos y tiempos del video | no medido |

## Ver también

- Guía anterior, con la técnica y los casos (en portugués): [inematds/rea-engenharia-reversa](https://inematds.github.io/rea-engenharia-reversa/guia/)
- REA: [github.com/morluto/rea](https://github.com/morluto/rea) · [rea.tools](https://rea.tools/)

## Licencia

MIT. Contenido abierto y gratuito de **[INEMA.CLUB](https://inema.club)**.