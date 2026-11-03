#!/usr/bin/env bash
# Utilidades para hooks de Claude Code. Los hooks reciben JSON por stdin.
HARNESS_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck source=../harness.config.sh
source "$HARNESS_ROOT/harness.config.sh"

TICKET="$(echo "${TICKET:-}" | tr '[:lower:]' '[:upper:]')"
TICKET_DIR="$HARNESS_ROOT/tickets/$TICKET"
WORKTREE="$HARNESS_ROOT/worktrees/$TICKET"
SESSION_FILE="$TICKET_DIR/session.md"

# Extrae un campo de tool_input del JSON del hook (usa node: viene con Claude Code).
tool_field() {
  local field="$1"
  printf '%s' "$HOOK_INPUT" | node -e '
    let s = ""; process.stdin.on("data", d => s += d).on("end", () => {
      try { const j = JSON.parse(s); const v = (j.tool_input || {})[process.argv[1]]; process.stdout.write(v == null ? "" : String(v)); }
      catch { process.stdout.write(""); }
    });' "$field"
}

# Devuelve contexto adicional a Claude en formato JSON de hook.
emit_context() {
  local event="$1" text="$2"
  node -e 'process.stdout.write(JSON.stringify({hookSpecificOutput:{hookEventName:process.argv[1],additionalContext:process.argv[2]}}))' "$event" "$text"
}

current_phase() {
  grep -m1 -E '^\*\*Fase actual:\*\*' "$SESSION_FILE" 2>/dev/null | sed -E 's/^\*\*Fase actual:\*\* *//' || true
}
