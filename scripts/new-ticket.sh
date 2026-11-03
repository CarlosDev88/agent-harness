#!/usr/bin/env bash
# Crea el entorno aislado de un ticket:
#   - git worktree en worktrees/TK-XXXX sobre la rama feature/TK-XXXX
#   - carpeta de estado tickets/TK-XXXX con session.md y plantillas
# Uso: scripts/new-ticket.sh TK-1400
source "$(dirname "$0")/lib.sh"
resolve_ticket "${1:-}"

# 1. Clon principal (una sola vez). Los worktrees comparten su .git.
if [[ ! -d "$REPO_DIR/.git" ]]; then
  log "clonando $REPO_URL en repo/"
  git clone "$REPO_URL" "$REPO_DIR"
fi
git -C "$REPO_DIR" fetch --quiet origin "$BASE_BRANCH"

# 2. Worktree del ticket
mkdir -p "$WORKTREES_DIR"
if [[ -d "$WORKTREE" ]]; then
  log "el worktree ya existe: worktrees/$TICKET"
elif git -C "$REPO_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$REPO_DIR" worktree add "$WORKTREE" "$BRANCH"
else
  git -C "$REPO_DIR" worktree add -b "$BRANCH" "$WORKTREE" "origin/$BASE_BRANCH"
fi

# 3. Estado del ticket (fuera del código base)
mkdir -p "$TICKET_DIR"/{tmp/cache,tests/fixtures,review}
for tpl in session mediciones preguntas criterios reglas; do
  dest="$TICKET_DIR/$tpl.md"
  [[ -e "$dest" ]] && continue
  sed -e "s|{{TICKET}}|$TICKET|g" \
      -e "s|{{RAMA}}|$BRANCH|g" \
      -e "s|{{FECHA}}|$(date +%Y-%m-%d)|g" \
      "$TEMPLATES_DIR/$tpl.md" > "$dest"
done

cat <<EOF

Ticket $TICKET listo.
  Código : worktrees/$TICKET  (rama $BRANCH)
  Estado : tickets/$TICKET/session.md

Abre la sesión del agente desde la raíz del arnés:
  TICKET=$TICKET claude --add-dir worktrees/$TICKET
y dile: "usa fases-ticket".
EOF
