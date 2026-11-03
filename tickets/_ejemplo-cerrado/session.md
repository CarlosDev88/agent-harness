# TK-0000 — session (EJEMPLO ILUSTRATIVO, datos ficticios)

> Así queda la carpeta de un ticket después del cierre: solo este archivo.
> Sirve para depurar un bug meses después: qué se decidió, con qué fuente, y qué hizo cada push.

**Fase actual:** 14 · Cerrado (en producción)
**Rama:** feature/TK-0000
**PR:** #000
**Abierto:** 2026-09-15
**Estado en la plataforma:** En producción

## Qué hace este ticket
Scraper de dictámenes de un organismo público. Ingesta los dictámenes publicados en el buscador oficial, con su PDF y metadatos (número, fecha, materia), excluyendo los que ya existían en la plataforma.

## Alcance
| Dato | Valor | Fuente |
|------|-------|--------|
| Fuente a scrapear | Buscador oficial de dictámenes | [tarea] |
| Documentos esperados | 4.210 en la fuente → 1.380 nuevos tras el cruce | [mediciones M-1] [cruce] |
| Tipos de documento | dictamen, aclaración, reconsideración | [mediciones M-2] |
| Fuera de alcance | documentos sin PDF (consultas en trámite) | [permalink Legal P-2] |

## Decisiones
- 2026-09-16 · Reconsideraciones se ingestan como documento propio enlazado al original · permalink Legal P-1
- 2026-09-16 · Clave natural = número + año (el número se reinicia cada año) · mediciones M-4
- 2026-09-17 · Partición del cruce por año (4 rangos de ~1.050 docs) · skill cruce-ingestas
- 2026-09-18 · Ejecutor con opus para el parser de materias (formato ambiguo), sonnet para el resto

## Loop de código
| Iteración | Modelo ejecutor | Auditor | Tester | Nota |
|-----------|-----------------|---------|--------|------|
| 1 | sonnet | RECHAZADO | — | regla R-3 implementada como lista de IDs (parche) |
| 2 | sonnet | APROBADO | ROJO | última página incompleta (E-1) |
| 3 | sonnet | APROBADO | VERDE | |

## Historial de pushes
| # | Fecha | Commit | Qué hace | Hallazgo que cierra |
|---|-------|--------|----------|---------------------|
| 1 | 2026-09-19 10:02 | `a1b2c3d` | TK-0000: scraper inicial de dictámenes | — |
| 2 | 2026-09-19 15:40 | `d4e5f6a` | TK-0000: timeouts y reintentos explícitos | Revisor IA medio: request sin timeout |
| 3 | 2026-09-20 09:15 | `b7c8d9e` | TK-0000: conteo de control al final de la corrida | Checklist de producción: falta reporte de ejecución |
| 4 | 2026-09-22 11:30 | `f0a1b2c` | TK-0000: materia nula explícita cuando no viene | Revisión humana: materia vacía como "" |

## Revisiones
| Ronda | Tipo | Resultado | Archivo |
|-------|------|-----------|---------|
| 1 | Revisor IA | 1 medio, 2 bajos | review/push-1-review.md |
| 2 | Revisor IA | verde | review/push-2-review.md |
| 3 | Checklist de producción | 1 pendiente | review/prod-checklist-1.md |
| 4 | Revisor IA + Checklist de producción | verde · todo OK | review/prod-checklist-2.md |
| 5 | Humano | 1 cambio | review/humano-1.md |
| 6 | Revisor IA + Checklist de producción | verde · todo OK | review/prod-checklist-3.md |

## Resultado
Nuevos ingestados: 1.380 · Ya ingestados (cruce): 2.790 · Excluidos por regla R-4 (sin PDF): 40 · Fallidos: 0 · Total = 4.210 = medido.

## Para depurar
- `scrapers/dictamenes/discover.py` → paginación (fin por página vacía, E-1)
- `scrapers/dictamenes/rules.py` → R-1 tipo de documento, R-3 reconsideración enlazada, R-4 exclusión sin PDF
- `scrapers/dictamenes/parse.py` → materia (nulo explícito)

## Cierre
- 2026-09-25: en producción. Temporales borrados; queda solo este archivo.
