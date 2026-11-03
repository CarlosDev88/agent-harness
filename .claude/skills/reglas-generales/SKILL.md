---
name: reglas-generales
description: Convierte cada criterio de la tabla final en una regla general de código y la prueba contra la fuente real con scripts temporales hasta que cumpla. Úsalo en la fase 8 y cuando un hallazgo exige una regla nueva.
---

# Reglas generales probadas

## 1. Redactar
Por cada criterio de `criterios.md` §Tabla final, escribe en `reglas.md`:
```
R-<n>  <nombre corto>
Criterio: C-<id>
Regla: <condición general sobre atributos medibles del documento>
Contraejemplo que NO debe cumplirla: <link real>
Ejemplo que SÍ: <link real>
```
Una regla que menciona un ID o URL concreto es un parche: reescríbela.

## 2. Probar contra la fuente
- Script `tickets/$TICKET/tmp/probar_regla_R<n>.<ext>` que aplica la regla sobre la muestra (o el universo si es barato) usando la caché del medidor.
- Resultado esperado: el conteo que cumple la regla coincide con lo que dice el criterio y con `mediciones.md`.
- Si no coincide: ajusta la regla (no el criterio). Si el criterio parece mal, vuelve a `preguntar-bot-legal`.

## 3. Registrar
En `reglas.md`, bajo cada regla: `Prueba: <script> → <cumplen>/<total> (fecha) — OK | AJUSTADA (motivo)`.
Solo pasan a diseño las reglas en `OK`.
