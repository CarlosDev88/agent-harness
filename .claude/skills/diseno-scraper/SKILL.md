---
name: diseno-scraper
description: Produce el diseño metodológico del scraper (diseno.md) combinando alcance, criterios, reglas probadas y las 11 reglas de diseño de código. Úsalo en la fase 9, antes de escribir código.
---

# Diseño metodológico del scraper

## Las 11 reglas de diseño
> Reconstrucción. Ajusta el texto a las reglas exactas del equipo.

1. **Una responsabilidad por capa:** descubrir (listar) → descargar → parsear → normalizar → persistir. Ninguna capa conoce a la siguiente por dentro.
2. **Seguir el patrón del repo:** el scraper nuevo copia la estructura del scraper vigente más parecido; las diferencias se justifican en el diseño.
3. **Reglas como funciones con nombre** (`R-<n>`), testeables por separado.
4. **Idempotencia:** correr dos veces no duplica; clave natural definida y documentada.
5. **Reanudable:** checkpoint de paginación; si cae en la página 300, sigue desde la 300.
6. **Respeto a la fuente:** rate limit, reintentos con backoff, timeouts explícitos, user-agent del equipo.
7. **Errores visibles:** nada de excepciones tragadas; cada documento que falla queda registrado con motivo.
8. **Sin datos hardcodeados:** URLs, selectores y rangos en configuración; sin IDs de casos puntuales.
9. **Metadatos completos o explícitamente nulos**, según el esquema del repo.
10. **Conteo de control:** al terminar, reporta encontrados / descargados / descartados por regla / fallidos, y debe cuadrar con `mediciones.md`.
11. **Observabilidad mínima:** logs estructurados con `ticket`, `fuente`, `documento`, `regla`.

## Contenido de `diseno.md`
1. Tarea y alcance (con fuentes).
2. Criterios de aceptación (copia de la tabla final).
3. Criterios jurídicos y técnicos separados.
4. Reglas generales probadas (`R-n` → función).
5. Arquitectura: capas, archivos a crear/modificar en el repo, scraper de referencia.
6. Cómo cumple cada una de las 11 reglas.
7. Plan de tests (insumo para `matriz-tests`).
8. Riesgos y preguntas abiertas.

Termina pidiendo aprobación al dev.
