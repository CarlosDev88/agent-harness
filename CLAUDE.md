# Arnés de tickets de scrapers

Este directorio es el **arnés**: vive *por encima* del código base de la empresa y nunca se mezcla con él.

```
agent-harness/        <- arnés (cwd de cada sesión de Claude Code)
├── repo/                    <- clon principal del código base (no se toca a mano)
├── worktrees/TK-XXXX/      <- un git worktree por ticket = una rama aislada
├── tickets/TK-XXXX/        <- estado del ticket: session.md, mediciones, criterios, tests, tmp
└── lessons/errores-compartidos.md  <- compendio de errores que leen TODOS los tickets
```

Cada sesión corre con la variable `TICKET` (ej. `TICKET=TK-1400`). El hook de inicio te dice cuál es tu ticket, tu worktree y tu fase actual. **Solo trabajas en tu ticket.**

## Reglas duras (no negociables)

1. **Prohibido responder de memoria.** Toda afirmación sobre la tarea, el alcance, el código o un criterio se respalda en una de estas tres fuentes, y se cita:
   - **Tarea** → la plataforma (o `tickets/$TICKET/tarea.md`, la copia que hizo el lector).
   - **Repositorio** → `worktrees/$TICKET/` (cita `ruta:línea`).
   - **Consultas** → permalinks de Slack a el bot interno o a Legal, registrados en `tickets/$TICKET/criterios.md`.
   Si no está en ninguna de las tres: dilo y propón una pregunta. No inventes.
2. **`session.md` es la fuente de verdad del estado.** Léelo antes de actuar y actualízalo al cerrar cada paso (fase, decisiones, pendientes). Así el estado sobrevive a las compactaciones.
3. **Nada temporal entra al código base.** Scripts de medición, tests sintéticos, borradores y salidas van en `tickets/$TICKET/` (`tmp/`, `tests/`, `review/`). El worktree solo recibe el código del scraper.
4. **Reglas generales, nunca parches.** Cada criterio y cada hallazgo se resuelve con una regla general que se prueba contra la fuente. Si la solución es un `if` para un caso puntual, está mal planteada.
5. **Puertas humanas.** Te detienes y esperas al dev en: (a) explicación de la tarea, (b) envío de preguntas a Slack, (c) aprobación del diseño, (d) aprobación de cada plan de hallazgos, (e) merge.
6. **Antes de preguntar, busca.** Duda técnica → revisa el repo; si no está, pregunta al bot interno. Duda de criterio jurídico → relee la tarea y los criterios; si sigue abierta, pregunta a Legal. Siempre con la skill `preguntar-bot-legal`.
7. **Cada error se comparte.** Todo hallazgo del revisor IA, del checklist de producción o revisión humana se registra en `lessons/errores-compartidos.md` con su causa raíz y el test que lo previene.
8. **Un ticket está terminado cuando está en producción**, no cuando se abre el PR ni cuando pasa a revisión.

## Fases (la skill `fases-ticket` es el orquestador)

| # | Fase | Salida en `tickets/$TICKET/` | Puerta |
|---|------|------------------------------|--------|
| 1 | Lectura de la tarea | `tarea.md` | El dev: "entendido" |
| 2 | Definición y alcance (cuántos docs, qué tipos) | `session.md` §Alcance | — |
| 3 | Mediciones de la fuente | `mediciones.md`, `tmp/medir_*.{py,ts}` | — |
| 4 | Contraste con tarea + repo y preguntas | `preguntas.md` | El dev envía a Slack |
| 5 | Permalinks y criterios | `criterios.md` (tabla con permalink por criterio) | — |
| 6 | Cruce contra lo ya ingestado (4 agentes en paralelo) | `cruce.md` | — |
| 7 | Tabla de criterios plana, sin solapes | `criterios.md` §Tabla final | — |
| 8 | Reglas generales probadas contra la fuente | `reglas.md`, `tmp/probar_regla_*` | — |
| 9 | Diseño metodológico (11 reglas de diseño) | `diseno.md` | El dev aprueba |
| 10 | Código: ejecutor ⇄ auditor ⇄ tester en loop | worktree + `tests/` | todo en verde |
| 11 | PR + loop del revisor IA (cada push) | `review/push-N-review.md`, `plan-hallazgos-N.md` | El dev aprueba cada plan |
| 12 | Checklist de producción | `review/prod-checklist-N.md` | — |
| 13 | Revisión humana → producción | `session.md` §Historial | merge |
| 14 | Cierre: borrar temporales, dejar solo `session.md` | `session.md` | — |

## Selección de modelo (ahorro de tokens)

- `haiku`: mecánico (copiar datos, formatear tablas, recolectar permalinks, leer logs de CI).
- `sonnet`: por defecto (mediciones, tests, auditoría, la mayoría del código).
- `opus`: lógica difícil (paginación rara, parsing ambiguo, diseño, planes de hallazgos con causa raíz no obvia).
Al lanzar un subagente, decide el modelo y deja la razón en una línea de `session.md`.
