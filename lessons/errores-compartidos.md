# Errores compartidos

> Compendio que leen **todos** los tickets. Lo alimentan los hallazgos del revisor IA, del checklist de producción y la revisión humana.
> El tester convierte cada entrada aplicable en un test de regresión; el auditor lo usa como checklist.
> Formato: una entrada por error, título `### E-<n> · <síntoma corto>`.

## Formato

```
### E-<n> · <síntoma corto>
- Ticket / fecha: TK-XXXX · AAAA-MM-DD
- Origen: Revisor IA (alto|medio|bajo) | Checklist de producción | Revisión humana
- Síntoma: qué se vio
- Causa raíz: por qué pasó (no el parche)
- Regla general: cómo se evita en cualquier scraper
- Test que lo previene: nombre del caso en la matriz (columna Regresión)
- Aplica a: todos | fuentes paginadas | PDFs | ...
```

## Entradas

> Las dos primeras son ejemplos ilustrativos del formato.

### E-1 · Conteo final no cuadra con la fuente
- Ticket / fecha: TK-0000 (ejemplo)
- Origen: Revisión humana
- Síntoma: el scraper reporta menos documentos que el contador de la fuente.
- Causa raíz: la última página devuelve menos resultados y el loop la trataba como "fin" antes de procesarla.
- Regla general: el fin de la paginación se decide por página vacía o por índice > último índice medido, nunca por "página incompleta".
- Test que lo previene: `regresion_E1_ultima_pagina_incompleta`
- Aplica a: fuentes paginadas

### E-2 · Excepción tragada oculta documentos fallidos
- Ticket / fecha: TK-0000 (ejemplo)
- Origen: Revisor IA (alto)
- Síntoma: `try/except: pass` alrededor de la descarga; documentos perdidos sin rastro.
- Causa raíz: se priorizó que el scraper "no se cayera" sobre registrar el fallo.
- Regla general: todo fallo por documento se registra con motivo y entra al conteo de control (regla de diseño 7 y 10).
- Test que lo previene: `regresion_E2_fallo_descarga_queda_registrado`
- Aplica a: todos
