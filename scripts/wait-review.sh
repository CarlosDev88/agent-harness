#!/usr/bin/env bash
# Después de un push: espera a que corran las GitHub Actions del revisor IA y trae
# el estado de los checks y los comentarios del bot sobre el último commit.
# Uso: TICKET=TK-1400 scripts/wait-review.sh [--no-wait]
source "$(dirname "$0")/lib.sh"
resolve_ticket ""
require_worktree

PR="$(pr_number)"
SHA="$(git -C "$WORKTREE" rev-parse HEAD)"
N="$(next_index push)"
OUT="$TICKET_DIR/review/push-$N-review.md"

if [[ "${1:-}" != "--no-wait" ]]; then
  log "PR #$PR, commit ${SHA:0:7}: esperando ${REVIEW_WAIT_SECONDS}s al revisor IA..."
  sleep "$REVIEW_WAIT_SECONDS"
fi

cd "$WORKTREE"
{
  echo "# Revisor IA — push $N"
  echo
  echo "- Ticket: $TICKET · PR: #$PR · Commit: \`${SHA:0:7}\` · Consultado: $(now_iso)"
  echo
  echo "## Checks"
  echo '```'
  gh pr checks "$PR" 2>&1 || true
  echo '```'
  echo
  echo "## Revisión general (reviews sobre este commit)"
  gh api "repos/{owner}/{repo}/pulls/$PR/reviews" --paginate --jq \
    ".[] | select(.commit_id == \"$SHA\") | select(.user.login | test(\"$REVIEW_BOT_PATTERN\"; \"i\")) | \"### \(.state)\n\n\(.body)\n\"" || true
  echo
  echo "## Hallazgos en línea (este commit)"
  gh api "repos/{owner}/{repo}/pulls/$PR/comments" --paginate --jq \
    ".[] | select(.commit_id == \"$SHA\") | select(.user.login | test(\"$REVIEW_BOT_PATTERN\"; \"i\")) | \"- **\(.path):\(.line // .original_line)** — \(.body | gsub(\"\n\"; \" \"))\"" || true
} > "$OUT"

log "guardado en tickets/$TICKET/review/push-$N-review.md"
echo "Siguiente: si hay hallazgos, lanza el agente revisor-hallazgos con ese archivo."
