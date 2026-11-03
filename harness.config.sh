# Configuración del arnés. Ajusta a tu entorno.
# Se carga desde scripts/lib.sh y hooks/*.sh

# Código base de la empresa (se clona en ./repo la primera vez)
REPO_URL="${REPO_URL:-git@github.com:ORG/scrapers.git}"
BASE_BRANCH="${BASE_BRANCH:-main}"
BRANCH_PREFIX="${BRANCH_PREFIX:-feature/}"

# Formato de los tickets de la plataforma
TICKET_REGEX='^[A-Z]+-[0-9]+$'

# Paralelismo: cuántos tickets a la vez (1 worktree + 1 sesión por ticket)
MAX_PARALLEL="${MAX_PARALLEL:-4}"

# Revisión automática en cada push (GitHub Actions del revisor IA)
REVIEW_WAIT_SECONDS="${REVIEW_WAIT_SECONDS:-300}"     # 5 min
REVIEW_BOT_PATTERN="${REVIEW_BOT_PATTERN:-review|bot}"     # regex sobre el login del bot

# Checklist de producción (se dispara con un comentario en el PR)
PROD_CHECKLIST_TRIGGER="${PROD_CHECKLIST_TRIGGER:-/prod-checklist}"
PROD_CHECKLIST_WAIT_SECONDS="${PROD_CHECKLIST_WAIT_SECONDS:-600}"   # 10 min
PROD_CHECKLIST_BOT_PATTERN="${PROD_CHECKLIST_BOT_PATTERN:-checklist|bot|github-actions}"

# Tests. Se ejecutan con cwd = worktree del ticket y con estas variables:
#   $WORKTREE  -> worktrees/TK-XXXX   (código)
#   $TICKET_DIR -> tickets/TK-XXXX    (tests sintéticos, fuera del repo)
SYNTH_TEST_CMD="${SYNTH_TEST_CMD:-PYTHONPATH=\"\$WORKTREE\" python -m pytest \"\$TICKET_DIR/tests\" -q}"
REPO_PRECHECK_CMD="${REPO_PRECHECK_CMD:-make check}"
