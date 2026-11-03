---
name: preguntar-bot-legal
description: Redacta preguntas para el bot interno (dudas técnicas) o para Legal (abogado, criterios jurídicos) después de verificar que la respuesta no está en la tarea ni en el repo. Úsalo en la fase 4, en planes de hallazgos y en devoluciones.
---

# Preguntar al bot interno o a Legal

## Paso 0 — ¿De verdad hay que preguntar?
| Tipo de duda | Antes de preguntar revisa | Si no está → pregunta a |
|---|---|---|
| Técnica (cómo se hace X en el repo, qué tabla/campo, qué convención) | El repo: busca scrapers similares, utilidades, docs | **Bot interno** |
| Criterio jurídico (qué documentos cuentan, cómo tratar versiones, vigencia, anexos) | `tarea.md` y `criterios.md` (incluidos permalinks ya respondidos) | **Legal** |

Si la respuesta aparece, regístrala con su fuente y **no preguntes**.

## Formato paral bot interno
```
@bot-interno [TK-XXXX] <pregunta en una línea>
Contexto: <qué estoy construyendo, 1–2 líneas>
Ya revisé: <rutas del repo que miré>
Necesito: <respuesta concreta esperada: ruta, nombre de función, sí/no>
```

## Formato para Legal
Lenguaje no técnico. Una pregunta por mensaje. Siempre con ejemplo real de la fuente.
```
[TK-XXXX] Consulta de criterio — <tema>
Situación: <qué encontramos en la fuente, con números de mediciones.md>
Ejemplo: <link al documento real>
Pregunta: <pregunta cerrada o con opciones>
  a) <opción>   b) <opción>   c) otra
Impacto: <cuántos documentos afecta>
```

## Salida
Escribe en `tickets/$TICKET/preguntas.md` una fila por pregunta:
`id | destinatario (bot/Legal) | pregunta | por qué no se resolvió con tarea/repo | estado (borrador/enviada/respondida) | permalink pregunta | permalink respuesta`

Luego **para** y entrega al dev los mensajes listos para pegar en el canal público de Slack.
