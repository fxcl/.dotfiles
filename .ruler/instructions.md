# Instrucciones del proyecto: Minimalist Portfolio JSON (Astro)

## Contexto y objetivo

Este repositorio contiene un portafolio/CV minimalista para web e impresión (PDF) basado en Astro 5, TypeScript y Tailwind CSS 4. Los datos provienen de `cv.json` (y `cv_english.json`) siguiendo el esquema de [jsonresume.org]. El objetivo es facilitar contribuciones seguras y repetibles: añadir secciones, actualizar datos, y mantener el build limpio.

Stack y tooling:

- Astro 5.13, TypeScript estricto, Tailwind 4, HotKeyPad (paleta de comandos), Ruler (.ruler/*) para agentes.
- Alias TS: `@/` → `src/*`, `@cv` → `./cv.json` (ver `tsconfig.json`).

Estructura relevante:

- `src/pages/index.astro`: página principal; importa y ordena las secciones.
- `src/components/sections/*`: secciones del CV (Hero, About, Experience, Education, Projects, Skills).
- `src/icons/*`: iconos SVG como componentes `.astro`.
- `src/cv.d.ts`: tipos del CV; respétalos al editar datos/consumir props.
- `src/styles/global.css`: estilos globales mínimos.

Scripts npm:

- `dev`/`start`: servidor de desarrollo.
- `build`: `astro check && astro build`.
- `preview`: vista previa de `dist/`.

## Checklist de requisitos verificables (para cualquier cambio)

- Build limpio: `astro check && astro build` sin errores ni warnings críticos.
- Sin cambios no relacionados ni reformateos masivos; minimizar el diff.
- Mantener convenciones:
  - Astro: componentes pequeños, props tipadas, nombres en PascalCase.
  - TypeScript: estricto, sin `any` innecesario, tipos en `src/*.d.ts`.
  - Tailwind 4: priorizar utilidades sobre CSS ad‑hoc; CSS global solo en `global.css`.
  - Rutas/alias: usar `@/` y `@cv` en imports.
- Accesibilidad básica: alt en imágenes, titles/aria si aplica.
- No introducir dependencias nuevas sin justificar; si se añaden, pínalas.
- Sin secretos/PII en commits, PRs ni código.

## Restricciones

- No modificar estilos globales salvo necesidad clara; preferir utilidades Tailwind locales.
- No romper el contrato de tipos de `src/cv.d.ts` al consumir datos de `cv.json`.
- Mantener el idioma de interfaz actual (es-ES) salvo que se indique lo contrario.
- No reordenar secciones en `index.astro` salvo requerimiento explícito.

## Criterios de aceptación (señales de éxito)

- Compila: `astro check` y `astro build` PASS.
- Previsualización local funciona sin errores de consola.
- La nueva funcionalidad/edición aparece donde corresponde y mantiene el diseño minimalista.
- No hay regresiones visuales evidentes en las secciones existentes.

## Entregables esperados

- Cambios de código/ficheros mínimos y autocontenidos.
- Si el cambio es visible: breve nota en `README.md` o comentarios en el PR.
- Si se añade una sección o icono: archivo en `src/components/sections/` o `src/icons/` y wiring en `src/pages/index.astro`.

## Tareas comunes (recetas)

### 1) Añadir una sección nueva (ej. “Certifications”)

1. Crear `src/components/sections/Certifications.astro` siguiendo el estilo de las secciones existentes e importando datos desde `@cv` si aplica.
2. Tipar props/datos con `src/cv.d.ts` (p. ej., `Certificates`). Evitar lógica compleja en `.astro`.
3. Importar y renderizar la sección en `src/pages/index.astro` en la posición deseada.
4. Ejecutar build y validar en preview.

Aceptación: build PASS y sección visible sin errores.

### 2) Actualizar datos del CV

1. Editar `cv.json` (o `cv_english.json` si se usa) respetando los tipos de `src/cv.d.ts`.
2. Verificar formato de fechas (`YYYY-MM-DD`) y campos obligatorios.
3. Build/preview para smoke test visual.

### 3) Añadir un icono

1. Crear `src/icons/NuevoIcono.astro` con SVG inline accesible.
2. Usarlo desde la sección correspondiente. Si aplica, mapear en constantes tipo `SocialIcon`.

### 4) Ajustar estilos mínimos

- Preferir utilidades Tailwind en el markup. Solo usar CSS en `global.css` si es global e inevitable.

### 5) Cambiar orden de secciones

- Editar el orden de imports/JSX en `src/pages/index.astro`. Validar visualmente.

## Calidad y validación

- Build: `npm run build` debe finalizar sin errores.
- Vista previa: `npm run preview` y comprobar navegación/acciones básicas (incluida la paleta de comandos/impresión).
- Sin errores de consola del navegador.

## Suposiciones y notas

- Alias TS definidos en `tsconfig.json`; usar `import { basics } from "@cv"` y `@/` para rutas internas.
- La paleta de comandos usa `hotkeypad`; evita introducir JavaScript en cliente pesado innecesario.

## Seguridad y licencias

- No exponer datos sensibles. Mantener MIT (ver `LICENSE.txt`).
- Si se agregan dependencias, preferir licencias permisivas y versiones fijas.

## Plantilla breve para pedir cambios

- Objetivo:
- Requisitos (checklist):
- Validación (cómo probar):
- Restricciones:
- Notas/contexto:

## Referencia rápida

- Desarrollo: `pnpm run dev`
- Build: `pnpm run build`
- Preview: `pnpm run preview`
