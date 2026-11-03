#!/usr/bin/env bash
# Utilidades compartidas por los scripts del arnés.
set -euo pipefail

HARNESS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../harness.config.sh
source "$HARNESS_ROOT/harness.config.sh"

REPO_DIR="$HARNESS_ROOT/repo"
WORKTREES_DIR="$HARNESS_ROOT/worktrees"
TICKETS_DIR="$HARNESS_ROOT/tickets"
TEMPLATES_DIR="$HARNESS_ROOT/templates"
LESSONS_FILE="$HARNESS_ROOT/lessons/errores-compartidos.md"

die() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "[arnés] $*" >&2; }

# Toma el ticket del primer argumento o de $TICKET y define rutas.
resolve_ticket() {
  TICKET="${1:-${TICKET:-}}"
  [[ -n "$TICKET" ]] || die "falta el ticket (argumento o variable TICKET)"
  TICKET="$(echo "$TICKET" | tr '[:lower:]' '[:upper:]')"
  [[ "$TICKET" =~ $TICKET_REGEX ]] || die "ticket inválido: $TICKET"
  WORKTREE="$WORKTREES_DIR/$TICKET"
  TICKET_DIR="$TICKETS_DIR/$TICKET"
  BRANCH="${BRANCH_PREFIX}${TICKET}"
  SESSION_FILE="$TICKET_DIR/session.md"
  export TICKET WORKTREE TICKET_DIR BRANCH SESSION_FILE
}

require_worktree() {
  [[ -d "$WORKTREE" ]] || die "no existe el worktree de $TICKET; corre scripts/new-ticket.sh $TICKET"
}

# Número de PR de la rama del ticket.
pr_number() {
  (cd "$WORKTREE" && gh pr view --json number -q .number 2>/dev/null) \
    || die "la rama $BRANCH no tiene PR abierto"
}

# Siguiente índice N para archivos review/<prefijo>-N-*.md
next_index() {
  local prefix="$1" n=1
  while compgen -G "$TICKET_DIR/review/${prefix}-${n}-*" >/dev/null \
     || [[ -e "$TICKET_DIR/review/${prefix}-${n}.md" ]]; do
    n=$((n + 1))
  done
  echo "$n"
}

now_iso() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
