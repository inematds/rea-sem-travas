#!/usr/bin/env bash
# rea-com-timeout.sh — roda um comando do REA (ou qualquer outro) com TETO de tempo e memória.
#
# Por quê: o REA 6.3.0 travou num app com um arquivo JS único gigante e ignorou o SIGTERM
# (precisou matar o processo órfão pelo PID). Na 6.4.0 o mesmo app terminou (94,5 s), mas
# o teto continua sendo a proteção barata contra a próxima trava.
#
# Uso:
#   scripts/rea-com-timeout.sh [-t SEGUNDOS] [-m MEMORIA] -- COMANDO [ARGS...]
#
# Exemplo:
#   scripts/rea-com-timeout.sh -t 600 -m 6G -- \
#     npx -y rea-agents@latest analyze-javascript-application /caminho/absoluto/app.asar --json > rea.json
#
# Como mata:
#   - Com systemd do usuário (host Linux): systemd-run --user --scope com RuntimeMaxSec e
#     MemoryMax. Ao estourar, o systemd mata o escopo inteiro (inclusive netos/órfãos).
#   - Sem systemd (ex.: dentro do container do dsh): GNU timeout manda SIGTERM ao grupo de
#     processos e, 10 s depois, SIGKILL (-k 10) para quem ignorou o SIGTERM.
# Código de saída 124 (timeout) ou 137 (morto) = estourou o teto; leia como "não terminou".
set -euo pipefail

T=600
M=6G
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t) T="$2"; shift 2;;
    -m) M="$2"; shift 2;;
    --) shift; break;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    *) echo "argumento desconhecido: $1 (use -- antes do comando)" >&2; exit 2;;
  esac
done
[[ $# -gt 0 ]] || { echo "faltou o comando depois de --" >&2; exit 2; }

if command -v systemd-run >/dev/null 2>&1 && systemctl --user show-environment >/dev/null 2>&1; then
  echo "[rea-com-timeout] systemd-run (MemoryMax=${M}) + timeout ${T}s (+10 s para SIGKILL)" >&2
  exec systemd-run --user --scope --quiet -p MemoryMax="${M}" -p MemorySwapMax=0 -- timeout -k 10 "${T}" "$@"
else
  echo "[rea-com-timeout] timeout: ${T}s (+10 s para SIGKILL); sem teto de memória neste modo" >&2
  exec timeout -k 10 "${T}" "$@"
fi
