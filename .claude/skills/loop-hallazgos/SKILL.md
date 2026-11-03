---
name: loop-hallazgos
description: Loop de revisión del PR. Modo review (GitHub Actions en cada push, espera 5 min) y modo prod-checklist (comentario en el PR, espera 10 min). Trae hallazgos, arma plan, espera aprobación, corrige, hace push y repite hasta verde. Úsalo en las fases 11–13.
---

# Loop de hallazgos

## Modo `review` (después de cada push)
1. `scripts/wait-review.sh` → espera 5 min, trae checks y comentarios del revisor IA a `tickets/$TICKET/review/push-<N>-review.md`.
2. Si no hay hallazgos y los checks están en verde → pasa a modo `prod-checklist`.
3. Si hay hallazgos (alto/medio/bajo):
   1. Lanza `revisor-hallazgos` → `plan-hallazgos-<N>.md` (reglas generales, sin parches, con fuentes: tarea + permalinks + repo).
   2. **PARA.** Muestra el plan al dev y espera "aprobado".
   3. Loop ejecutor → auditor → tester (como en la fase 10).
   4. `git push` (el hook registra el push en `session.md`).
   5. Vuelve al paso 1.

## Modo `prod-checklist`
1. `scripts/prod-checklist.sh` → comenta el disparador en el PR, espera 10 min y guarda la respuesta en `review/prod-checklist-<N>.md`.
2. Si todos los chequeos pasan → mueve el ticket a "Listo para revisión" en la plataforma y anota en `session.md`.
3. Si hay hallazgos → mismo ciclo: plan → aprobación → código → push → **modo review** → cuando el revisor IA está verde, otra vez prod-checklist.

## Devolución humana
Guarda el comentario en `review/humano-<N>.md` y regresa a la fase 4 de `fases-ticket` (releer tarea, revisar permalinks, preguntar si hace falta). Después, mismo loop.

## Siempre
- Cada hallazgo nuevo → `lessons/errores-compartidos.md`.
- Cada push → una línea en `session.md` §Historial de pushes: N, sha, qué cambió, qué hallazgo cierra.
