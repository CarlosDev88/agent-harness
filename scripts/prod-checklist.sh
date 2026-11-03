#!/usr/bin/env bash
# Dispara la validación del checklist de producción comentando en el PR, espera y trae
# la respuesta del bot.
# Uso: TICKET=TK-1400 scripts/prod-checklist.sh [--no-trigger] [--no-wait]
source "$(dirname "$0")/lib.sh"
resolve_ticket ""
require_worktree

trigger=1; wait=1
for a in "$@"; do
  case "$a" in
    --no-trigger) trigger=0 ;;
    --no-wait) wait=0 ;;
  esac
done

PR="$(pr_number)"
N="$(next_index prod-checklist)"
OUT="$TICKET_DIR/review/prod-checklist-$N.md"
SINCE="$(now_iso)"

cd "$WORKTREE"
if (( trigger )); then
  gh pr comment "$PR" --body "$PROD_CHECKLIST_TRIGGER"
  log "Checklist de producción disparado en PR #$PR"
fi
if (( wait )); then
  log "esperando ${PROD_CHECKLIST_WAIT_SECONDS}s..."
  sleep "$PROD_CHECKLIST_WAIT_SECONDS"
fi

{
  echo "# Checklist de producción — corrida $N"
  echo
  echo "- Ticket: $TICKET · PR: #$PR · Disparado: $SINCE · Consultado: $(now_iso)"
  echo
  gh api "repos/{owner}/{repo}/issues/$PR/comments" --paginate --jq \
    ".[] | select(.created_at >= \"$SINCE\") | select(.user.login | test(\"$PROD_CHECKLIST_BOT_PATTERN\"; \"i\")) | \"## \(.user.login) · \(.created_at)\n\n\(.body)\n\"" || true
} > "$OUT"

if [[ "$(wc -l < "$OUT")" -le 4 ]]; then
  log "todavía no hay respuesta del bot; vuelve a consultar con: $0 --no-trigger --no-wait"
fi
log "guardado en tickets/$TICKET/review/prod-checklist-$N.md"
