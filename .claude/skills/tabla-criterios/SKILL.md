---
name: tabla-criterios
description: Construye la tabla final de criterios del ticket (técnicos y jurídicos) a partir de la tarea, el cruce y las respuestas de bot/Legal. Plana y sin solapes. Úsalo en la fase 7.
---

# Tabla de criterios

Entradas: `tarea.md`, `cruce.md`, `preguntas.md` (respondidas), `mediciones.md`.

## Reglas de la tabla
1. **Plana:** una fila = un criterio verificable. Nada de sub-criterios ni filas que dependan de otras.
2. **Sin solapes:** cada documento de la fuente cae en exactamente una regla de inclusión/exclusión. Comprueba con los números: la suma de documentos cubiertos por los criterios de inclusión + exclusión = total medido.
3. **Con fuente:** cada fila cita `tarea`, `repo:ruta` o un permalink de Slack.
4. **Verificable:** cada fila dice cómo se comprueba (consulta, test, conteo).

## Formato (en `criterios.md` §Tabla final)
| ID | Tipo (técnico/jurídico) | Criterio | Fuente (permalink/tarea/repo) | Cómo se verifica | Docs afectados |
|----|----|----|----|----|----|

## Chequeo de solapes
Para cada par de criterios de inclusión/exclusión, pregunta: ¿existe un documento que cumpla ambos? Si sí, fusiona o separa por un atributo medible y vuelve a contar.
