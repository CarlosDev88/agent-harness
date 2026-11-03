#!/usr/bin/env bash
# UserPromptSubmit: antes de cada mensaje del dev, recuerda ticket, fase y la
# regla de las tres fuentes. Cuesta pocas líneas y baja mucho las alucinaciones.
source "$(dirname "$0")/lib.sh"
cat >/dev/null

[[ -n "$TICKET" ]] || exit 0
phase="$(current_phase)"
echo "[arnés] $TICKET · Fase actual: ${phase:-desconocida (lee session.md)} · Responde con fuentes: tarea, repo (ruta:línea) o permalink. Si no está, dilo y propón una pregunta."
