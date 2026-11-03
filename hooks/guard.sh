#!/usr/bin/env bash
# PreToolUse (Bash | Write | Edit): barandas del arnés.
# exit 2 = bloquear la acción; el mensaje de stderr vuelve a Claude.
source "$(dirname "$0")/lib.sh"
HOOK_INPUT="$(cat)"

block() { echo "[arnés] BLOQUEADO: $*" >&2; exit 2; }

cmd="$(tool_field command)"
path="$(tool_field file_path)"

if [[ -n "$cmd" ]]; then
  # Nunca push directo a la rama principal ni force sin lease.
  if [[ "$cmd" =~ git[[:space:]].*push ]]; then
    [[ "$cmd" =~ (^|[[:space:]:])(main|master|$BASE_BRANCH)([[:space:]]|$) ]] \
      && block "push a la rama principal. Se trabaja en ${BRANCH_PREFIX}TK-XXXX con PR."
    [[ "$cmd" =~ (--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$)) ]] \
      && block "force push. Usa --force-with-lease si de verdad hace falta y explícalo en session.md."
  fi
  # Nada de borrar el clon principal ni worktrees a mano.
  if [[ "$cmd" =~ rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*[[:space:]].*(repo|worktrees)(/|[[:space:]]|$) ]]; then
    block "borrado manual de repo/ o worktrees/. Usa scripts/close-ticket.sh."
  fi
fi

if [[ -n "$path" ]]; then
  # Los temporales del ticket no entran al código base.
  if [[ "$path" == *"/worktrees/"* ]]; then
    base="$(basename "$path")"
    case "$base" in
      session.md|mediciones.md|preguntas.md|criterios.md|reglas.md|diseno.md|MATRIZ.md|medir_*|probar_regla_*|plan-hallazgos*)
        block "$base es un archivo del arnés; va en tickets/\$TICKET/, no en el worktree." ;;
    esac
  fi
  # Cada sesión solo escribe en su ticket.
  if [[ -n "$TICKET" && "$path" =~ /(tickets|worktrees)/([A-Z]+-[0-9]+)/ ]]; then
    other="${BASH_REMATCH[2]}"
    [[ "$other" == "$TICKET" ]] || block "esta sesión es de $TICKET y está escribiendo en $other."
  fi
fi

exit 0
