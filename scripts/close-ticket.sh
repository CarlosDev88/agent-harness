#!/usr/bin/env bash
# Cierra un ticket desplegado en producción:
#   - verifica que el PR esté MERGED
#   - elimina worktree y rama local
#   - borra temporales y deja solo session.md como historial
# Uso: scripts/close-ticket.sh TK-1400 [--force]   (--force omite la verificación del PR)
source "$(dirname "$0")/lib.sh"
resolve_ticket "${1:-}"
force="${2:-}"

[[ -f "$SESSION_FILE" ]] || die "no existe tickets/$TICKET/session.md"

if [[ "$force" != "--force" ]]; then
  require_worktree
  state="$(cd "$WORKTREE" && gh pr view --json state -q .state)"
  [[ "$state" == "MERGED" ]] || die "el PR de $TICKET está en estado $state, no MERGED"
fi

read -r -p "¿$TICKET ya está en PRODUCCIÓN? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || die "cancelado: un ticket se cierra cuando está en producción"

if [[ -d "$WORKTREE" ]]; then
  git -C "$REPO_DIR" worktree remove --force "$WORKTREE"
  log "worktree eliminado"
fi
git -C "$REPO_DIR" branch -D "$BRANCH" 2>/dev/null && log "rama local $BRANCH eliminada" || true
git -C "$REPO_DIR" worktree prune

find "$TICKET_DIR" -mindepth 1 -maxdepth 1 ! -name session.md -exec rm -rf {} +
printf '\n## Cierre\n- %s: en producción. Temporales borrados; queda solo este archivo.\n' "$(date +%Y-%m-%d)" >> "$SESSION_FILE"

log "$TICKET cerrado. Queda tickets/$TICKET/session.md"
