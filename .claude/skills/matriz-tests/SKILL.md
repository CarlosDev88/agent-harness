---
name: matriz-tests
description: Genera tests sintéticos a partir de una matriz criterios × casos, guardados fuera del código base en tickets/$TICKET/tests, y los corre junto con los pre-checks del repo. Úsalo desde el agente tester.
---

# Matriz de tests sintéticos

## 1. Matriz (`tickets/$TICKET/tests/MATRIZ.md`)
Filas = cada criterio `C-*` y cada regla `R-*`. Columnas = casos:
| ID | Normal | Borde | Error de fuente | Regresión (errores-compartidos) | Test(s) |
|----|--------|-------|-----------------|---------------------------------|---------|

- **Normal:** documento típico que cumple.
- **Borde:** página vacía, último índice, campo nulo, fecha límite, documento con anexos.
- **Error de fuente:** 404, 500, timeout, HTML cambiado, PDF corrupto.
- **Regresión:** cada error de `lessons/errores-compartidos.md` que aplique a este scraper.

Ninguna celda vacía: si no aplica, escribe `n/a` y por qué.

## 2. Fixtures
Solo respuestas reales guardadas por el medidor (`tmp/cache/` → `tests/fixtures/`). Para errores, una respuesta real modificada y marcada como tal.

## 3. Tests
- Viven en `tickets/$TICKET/tests/`; importan el código desde `worktrees/$TICKET/`.
- Un test por celda; el nombre incluye el ID (`test_R3_borde_pagina_vacia`).
- Se corren con `scripts/run-tests.sh synth` (configurado en `harness.config.sh`).

## 4. Pre-checks del repo
`scripts/run-tests.sh repo` corre lo que exige la empresa (lint, tipos, tests del repo, skills de validación del código base). Ambos deben estar en verde.
