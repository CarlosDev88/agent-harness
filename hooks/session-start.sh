#!/usr/bin/env bash
# SessionStart (startup | resume | compact | clear)
# Reinyecta el estado del ticket para que sobreviva a las compactaciones.
# Lo que este hook imprime por stdout entra al contexto de Claude.
source "$(dirname "$0")/lib.sh"
cat >/dev/null  # consumir stdin

if [[ -z "$TICKET" ]]; then
  echo "[arnés] Sesión sin TICKET. Tickets con estado en tickets/:"
  ls -1 "$HARNESS_ROOT/tickets" 2>/dev/null | sed 's/^/  - /'
  echo "Abre la sesión con: TICKET=TK-XXXX claude --add-dir worktrees/TK-XXXX"
  exit 0
fi

echo "[arnés] TICKET ACTIVO: $TICKET"
echo "  Código (worktree): worktrees/$TICKET"
echo "  Estado:            tickets/$TICKET/"
echo "  Trabaja SOLO en este ticket. No respondas de memoria: tarea + repo + permalinks."
echo

if [[ -f "$SESSION_FILE" ]]; then
  echo "===== tickets/$TICKET/session.md (fuente de verdad del estado) ====="
  cat "$SESSION_FILE"
  echo "===== fin session.md ====="
else
  echo "No existe session.md. Corre scripts/new-ticket.sh $TICKET"
fi

LESSONS="$HARNESS_ROOT/lessons/errores-compartidos.md"
if [[ -f "$LESSONS" ]]; then
  total="$(grep -c '^### ' "$LESSONS" || true)"
  echo
  echo "[arnés] lessons/errores-compartidos.md tiene $total errores registrados. Últimos:"
  grep '^### ' "$LESSONS" | tail -n 8 | sed 's/^### /  - /'
fi
