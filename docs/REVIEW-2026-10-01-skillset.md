# Skillset Review — diagnóstico y propuesta

- **Fecha:** 2026-10-01
- **Estado:** Propuesta pendiente de aprobación. Siguiente paso sugerido: P0 primero.
- **Alcance:** 16 skills en `~/.config/opencode/skills/` (`SKILL.md` + `references/` + `evals/` de cada una,
  pipeline de `skillset-dev-orchestrator`, evals de triggering).
- **Objetivo:** hacer el skillset más útil entre sesiones, proyectos, flujos y entornos distintos.
- **Cómo retomar:** en una sesión posterior, leer este archivo y ejecutar en orden P0 → P1 → P2
  (ver §5). Hacer bump de versión + entrada en `CHANGELOG.md` por cada cambio de comportamiento.

## 1. Caso que motivó la revisión

En una sesión de trabajo (proyecto `alfred`) el agente implementó cambios y cerró con un
`git commit` automático sin haber cargado nunca `skillset-git-workflow`, aunque esa skill
ya contiene el principio exacto aplicable ("No auto-commit/push. Default: never `commit`/`push`
without an explicit request", principio 6).

Conclusión: **el contenido estaba correcto; falló el disparo (routing), no la redacción.**
Las skills son opt-in por contexto a discreción del agente. Una regla inviolable no puede vivir
solo en una skill que quizá nunca se cargue: los constraints duros van en instrucciones
always-on (prompt del sistema / `AGENTS.md` del repo); las skills quedan para conocimiento
procedimental (formatos, secuencias, criterios).

## 2. Lo que está bien (no tocar)

- Estándar consistente: frontmatter (`name`/`description`/`license`/`allowed-tools`/`metadata.version`),
  cuerpos lean (≤60 líneas) con detalle en `references/`, todo project-agnostic.
- `allowed-tools` con scope correcto (orchestrator y discovery solo-lectura; git sin Write/Edit).
- Desambiguación mutua en las descripciones ("Do not use for X — use Y") bien hecha.
- Los 16 evals de triggering son únicos (no copy-paste), cada uno customizado a su skill.
- El pipeline del orchestrator con gates por fase es la arquitectura correcta para trabajo multi-fase.

## 3. Bugs del harness (reparar primero)

1. **`docs/ROUTING.md` no existe.** Las 16 skills lo referencian ("Routing conflicts: see
   `docs/ROUTING.md`"), igual que el orchestrator y `references/pipeline.md`. El mecanismo
   designado para desempatar "¿qué skill?" es un puntero colgado; sin esto, la promesa central
   del orchestrator está hueca.
   - Nota 2026-10-01: `docs/ROUTING.md` ya existe en el repo `skillset` — verificar si cubre
     la matriz + desempates y cerrar este punto o completar lo que falte.
2. **Puntero colgado a "systematic debugging"** en la descripción de `skillset-dev-feature`
   ("Do not use for bug fixes ... use systematic debugging or skillset-docs-discovery").
   Esa skill no existe: un bug del día a día no tiene dueño claro (`dev-feature` lo rechaza
   explícito, `dev-testing` lo cubre a medias).
3. **Referencias rotas del creator**: `package_skill.sh`, `install.sh`, `validate-pack.py` y
   `VERSION` no existen aunque `skillset-creator` (y el orchestrator) los exigen. Crear o
   corregir el estándar.
   - Nota 2026-10-01: en el repo `skillset` sí existen `install.sh`, `VERSION` y
     `scripts/validate-pack.py` (verificar nombre real: `package_skill.sh` vs `package-skill`).
     Reconciliar nombres y cerrar o corregir.
4. **El eval de git-workflow no cubre el fallo real**: trae 5 should-trigger + 3 should-NOT
   (el estándar del creator pide 5+5) y ningún caso incidental (p. ej. "procede" → commit
   automático sin cargar la skill).

## 4. Huecos para el día a día (multi-proyecto, multi-entorno)

5. **Sin skill de ops/deploy.** Deploys nativos + Docker + systemd + healthchecks + paridad de
   entornos no tienen dueña, aunque son trabajo recurrente.
6. **Sin skill de debugging dedicada** (ver bug 2): reproducir → bisectar → fix → regression
   test como flujo propio end-to-end.
7. **Sin capa de adaptación por proyecto/entorno.** El pack es genérico (correcto), pero nada
   declara el perfil de cada proyecto: qué skills aplican, reglas fijas
   (p. ej. "deploy nativo a RPi", "jamás auto-commit", "Node ≥22"), entorno destino.
   Cada sesión en un proyecto distinto empieza de cero.
8. **Sin constraints always-on del harness.** Reglas como "no auto-commit/push" necesitan un
   canal que el agente vea siempre (bloque global inyectado cada sesión o puntero en el
   `AGENTS.md` de cada repo), no una skill opt-in.

## 5. Propuesta concreta, en orden

- **P0 (reparar):** crear `docs/ROUTING.md` (matriz tarea→skill + desempates, incluyendo casos
  incidentales); reparar o podar las 4 referencias rotas; añadir al eval de git-workflow los
  casos incidentales y completar 5+5. Bump de versión donde aplique.
- **P1 (nuevas skills):** `skillset-dev-debugging` (dueña de bugfixing; `dev-testing` se queda
  con higiene del suite) y `skillset-ops-deploy` (nativo/docker/servicios/healthchecks/paridad
  de envs; decisiones de referencia: Linux-first, Win/Mac→contenedores, fail-fast con mensajes
  accionables, workspace de datos separado del repo).
- **P2 (multi-proyecto):** convención de "perfil por proyecto" — sección fija en el `AGENTS.md`
  de cada repo (skills activas + reglas fijas + entorno destino) — más un bloque de constraints
  always-on del harness (ahí vive "no auto-commit", no en una skill).

## 6. Estado

Propuesta pendiente de aprobación. Siguiente paso sugerido: P0 primero.
