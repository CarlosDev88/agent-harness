---
name: cruce-ingestas
description: Lanza 4 agentes cruce-ingestas en paralelo (una pestaña de la plataforma cada uno) para saber qué documentos del ticket ya fueron ingestados por otros tickets, y consolida el resultado. Úsalo en la fase 6.
---

# Cruce contra lo ya ingestado

**Por qué:** otros desarrolladores, en otros tickets, pueden haber ingestado todos, algunos o ninguno de los documentos que este ticket va a traer. Sin cruce se duplica trabajo o datos.

## 1. Partir el universo en 4
Con `mediciones.md`, elige el criterio de partición que deje 4 partes de tamaño parecido y sin solape:
- por **tipo de documento** si hay ≥4 tipos con volumen similar;
- si no, por **rango de fechas**;
- si no, por **rango de IDs** de la fuente.
Escribe la partición en `cruce.md` §Partición antes de lanzar.

## 2. Lanzar en paralelo
En **un solo mensaje**, lanza 4 subagentes `cruce-ingestas`, cada uno con `TICKET`, su número de parte y el rango que le toca. Modelo: `sonnet` (o `haiku` si la búsqueda es por ID exacto).

## 3. Consolidar
Cuando terminen los 4, une `tmp/cruce-parte-{1..4}.md` en `cruce.md`:
- conteo total por categoría (`NUEVO`, `INGESTADO`, `PARCIAL`, `EN_CURSO`, `DUDA`) y verifica que la suma = total medido;
- lista de `EN_CURSO` con el ticket dueño (posible coordinación con otro dev);
- lista de `DUDA` → candidatas a pregunta (`preguntar-bot-legal`).

Si la suma no cuadra con las mediciones, no sigas: repite la parte que falla.
