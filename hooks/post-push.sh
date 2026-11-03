#!/usr/bin/env bash
# PostToolUse (Bash): cuando el agente hace git push, registra el push en
# session.md (historial para depurar después) y recuerda lanzar el loop del revisor IA.
source "$(dirname "$0")/lib.sh"
HOOK_INPUT="$(cat)"

cmd="$(tool_field command)"
[[ "$cmd" =~ git[[:space:]].*push ]] || exit 0
[[ -n "$TICKET" && -f "$SESSION_FILE" && -d "$WORKTREE" ]] || exit 0

sha="$(git -C "$WORKTREE" rev-parse --short HEAD 2>/dev/null || echo '?')"
# Evitar duplicados si el mismo commit ya se registró.
grep -q "| \`$sha\` |" "$SESSION_FILE" && exit 0

n="$(grep -cE '^\| [0-9]+ \|' "$SESSION_FILE" || true)"
n=$((n + 1))
subject="$(git -C "$WORKTREE" log -1 --pretty=%s 2>/dev/null | tr '|' '/')"
row="| $n | $(date '+%Y-%m-%d %H:%M') | \`$sha\` | $subject | _completar: hallazgo que cierra_ |"

# Inserta la fila al final de la tabla "Historial de pushes".
node -e '
  const fs = require("fs"); const [file, row] = process.argv.slice(1);
  const lines = fs.readFileSync(file, "utf8").split("\n");
  const h = lines.findIndex(l => /^## Historial de pushes/.test(l));
  if (h < 0) { fs.appendFileSync(file, "\n" + row + "\n"); process.exit(0); }
  let i = h + 1;
  while (i < lines.length && !/^\|/.test(lines[i])) i++;
  while (i < lines.length && /^\|/.test(lines[i])) i++;
  lines.splice(i, 0, row);
  fs.writeFileSync(file, lines.join("\n"));
' "$SESSION_FILE" "$row"

emit_context PostToolUse "[arnés] Push $n ($sha) registrado en session.md. Completa qué hallazgo cierra y corre scripts/wait-review.sh (loop-hallazgos, modo review)."
