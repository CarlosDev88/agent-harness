#!/usr/bin/env bash
# Levanta hasta MAX_PARALLEL tickets en paralelo: un worktree + una sesión de
# Claude Code por ticket, cada una en su ventana de tmux.
# Uso: scripts/parallel.sh TK-1400 TK-1401 TK-1402 TK-1403
source "$(dirname "$0")/lib.sh"

(( $# >= 1 )) || die "uso: $0 TK-XXXX [TK-YYYY ...]"
(( $# <= MAX_PARALLEL )) || die "máximo $MAX_PARALLEL tickets en paralelo"

for t in "$@"; do
  "$HARNESS_ROOT/scripts/new-ticket.sh" "$t" >/dev/null
done

launch_cmd() { echo "cd '$HARNESS_ROOT' && TICKET=$1 claude --add-dir worktrees/$1"; }

if command -v tmux >/dev/null 2>&1; then
  SESSION="arnes"
  tmux has-session -t "$SESSION" 2>/dev/null && die "ya existe la sesión tmux '$SESSION' (tmux attach -t $SESSION)"
  first=1
  for t in "$@"; do
    t="$(echo "$t" | tr '[:lower:]' '[:upper:]')"
    if (( first )); then
      tmux new-session -d -s "$SESSION" -n "$t" "$(launch_cmd "$t")"
      first=0
    else
      tmux new-window -t "$SESSION" -n "$t" "$(launch_cmd "$t")"
    fi
  done
  log "sesiones listas. Entra con: tmux attach -t $SESSION  (Ctrl-b n = siguiente ticket)"
  exec tmux attach -t "$SESSION"
else
  log "tmux no está instalado. Abre una pestaña de terminal por ticket y corre:"
  for t in "$@"; do
    echo "  $(launch_cmd "$(echo "$t" | tr '[:lower:]' '[:upper:]')")"
  done
fi
