---
name: cerrar-ticket
description: Cierra un ticket ya desplegado en producción - verifica merge, borra temporales y el worktree, y deja solo session.md como historial. Úsalo en la fase 14.
---

# Cierre del ticket

1. Confirma con el dev que el ticket está **en producción** (no solo mergeado).
2. Completa `session.md`:
   - §Resultado: documentos ingestados por categoría (vs. lo medido).
   - §Historial de pushes completo y PR final.
   - §Para depurar: qué archivos del repo tocó el ticket y qué regla vive en cada uno.
3. Corre `scripts/close-ticket.sh $TICKET`:
   - verifica que el PR esté `MERGED`;
   - elimina el worktree y la rama local;
   - borra todo en `tickets/$TICKET/` excepto `session.md`.
4. Revisa que `lessons/errores-compartidos.md` tenga todo lo aprendido en este ticket.
