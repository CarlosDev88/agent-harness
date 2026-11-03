---
name: fases-ticket
description: Orquestador del ticket de scraper de principio a fin (fases 1–14). Úsalo al iniciar un ticket, al retomarlo después de una compactación o cuando el dev diga "sigue".
---

# Orquestador de fases

Siempre empieza leyendo `tickets/$TICKET/session.md` → campo **Fase actual**. Retoma desde ahí; no repitas fases cerradas.
Al cerrar cada fase: actualiza `session.md` (fase, decisiones con fuente, pendientes) **antes** de pasar a la siguiente.

## 1. Lectura de la tarea
- Lanza `lector-tarea`. Muestra al dev la explicación.
- **PARA.** Solo sigue cuando el dev responda "entendido". Si corrige algo, anótalo en `session.md` §Decisiones.

## 2. Definición y alcance
- Con `tarea.md` y el repo: qué fuente, cuántos documentos se espera ingestar, de qué tipos, qué queda fuera.
- Escríbelo en `session.md` §Alcance marcando cada dato como `[tarea]`, `[repo]` o `[por medir]`.

## 3. Mediciones
- Lanza `medidor` con todo lo marcado `[por medir]`. Puedes lanzar varios medidores en paralelo si miden cosas independientes (ej. volumen vs. formatos).
- Resultado en `mediciones.md`.

## 4. Contraste y preguntas
- Contrasta mediciones vs. `tarea.md` vs. repo. Cada diferencia es: (a) resuelta por el repo, (b) duda técnica, (c) duda de criterio jurídico.
- Para (b) y (c) usa la skill `preguntar-bot-legal`. Resultado en `preguntas.md`.
- **PARA.** El dev revisa y publica las preguntas en el canal público de Slack.

## 5. Permalinks y criterios
- Recoge el permalink de cada pregunta y su respuesta (Slack MCP si está disponible; si no, el dev los pega).
- Registra cada criterio con su permalink en `criterios.md` (plantilla). Un criterio sin fuente no entra.

## 6. Cruce
- Skill `cruce-ingestas` (4 agentes en paralelo). Resultado en `cruce.md`.

## 7. Tabla de criterios final
- Skill `tabla-criterios`: tarea + cruce + respuestas → tabla **plana y sin solapes**.

## 8. Reglas generales
- Skill `reglas-generales`: cada criterio → una regla de código, probada contra la fuente con scripts temporales hasta que cumpla. Resultado en `reglas.md`.

## 9. Diseño metodológico
- Skill `diseno-scraper`: alcance + criterios + reglas probadas + 11 reglas de diseño → `diseno.md`.
- **PARA.** El dev aprueba el diseño.

## 10. Código en loop
```
iteración = 1
mientras iteración <= 5:
    ejecutor (modelo según complejidad)  -> cambios en worktree
    auditor                              -> APROBADO | RECHAZADO
    si RECHAZADO: devolver observaciones al ejecutor; iteración += 1; continuar
    tester                               -> VERDE | ROJO
    si ROJO: devolver fallos al ejecutor; iteración += 1; continuar
    salir
si iteración > 5: PARA y explica al dev qué no converge.
```
Anota cada iteración en `session.md` §Loop (una línea: iteración, modelo, veredicto).

## 11. PR y loop del revisor IA
- Crea rama/PR desde el worktree (`gh pr create`), anota el número en `session.md`.
- Skill `loop-hallazgos` modo `review` después de **cada** push.

## 12. Checklist de producción
- Cuando el revisor IA está en verde: skill `loop-hallazgos` modo `prod-checklist`.
- Si hay hallazgos: plan → aprobación → código → push → vuelve al revisor IA → vuelve al checklist de producción.
- En verde: mueve el ticket a "Listo para revisión" en la plataforma.

## 13. Revisión humana
- Si devuelven cambios: guarda el comentario en `review/humano-N.md` y vuelve a la **fase 4** (releer tarea, revisar preguntas, preguntar si hace falta) → plan → código → Revisor IA → Checklist de producción.
- Si aprueban: merge y espera el despliegue.

## 14. Cierre
- Cuando el ticket está **en producción**: skill `cerrar-ticket`.
