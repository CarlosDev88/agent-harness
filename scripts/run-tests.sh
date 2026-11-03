#!/usr/bin/env bash
# Corre los tests del ticket.
#   synth -> tests sintéticos de tickets/$TICKET/tests (fuera del repo)
#   repo  -> pre-checks obligatorios del código base
#   all   -> ambos (por defecto)
# Uso: TICKET=TK-1400 scripts/run-tests.sh [synth|repo|all]
source "$(dirname "$0")/lib.sh"
resolve_ticket ""
require_worktree

mode="${1:-all}"
out="$TICKET_DIR/tests/ultima-corrida.txt"
status=0

run() {
  local name="$1" cmd="$2"
  echo "===== $name: $cmd" | tee -a "$out"
  if (cd "$WORKTREE" && eval "$cmd") >>"$out" 2>&1; then
    echo "===== $name: VERDE" | tee -a "$out"
  else
    echo "===== $name: ROJO" | tee -a "$out"
    status=1
  fi
}

: > "$out"
echo "# $(now_iso) $TICKET" >> "$out"
case "$mode" in
  synth) run synth "$SYNTH_TEST_CMD" ;;
  repo)  run repo  "$REPO_PRECHECK_CMD" ;;
  all)   run synth "$SYNTH_TEST_CMD"; run repo "$REPO_PRECHECK_CMD" ;;
  *) die "modo inválido: $mode" ;;
esac

echo "Salida completa: tickets/$TICKET/tests/ultima-corrida.txt"
exit "$status"
