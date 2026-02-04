# Contribuir a updateLITE · Fedora Edition

Gracias por tu interés en contribuir a updateLITE. Este documento proporciona las guías y mejores prácticas para contribuir al proyecto.

## Código de Conducta

Por favor, sé respetuoso y constructivo en todas las interacciones relacionadas con este proyecto.

## Cómo Contribuir

### Reportar Bugs

Si encuentras un bug, por favor abre un issue incluyendo:

1. Descripción clara del problema
2. Pasos para reproducirlo
3. Comportamiento esperado vs comportamiento actual
4. Versión de Fedora
5. Versión de updateLITE (`updatelite --version`)
6. Logs relevantes (si aplica)

### Sugerir Mejoras

Las sugerencias son bienvenidas. Abre un issue describiendo:

1. La mejora propuesta
2. Por qué sería útil
3. Posibles implementaciones (si tienes ideas)

### Pull Requests

1. Haz fork del repositorio
2. Crea una rama para tu feature: `git checkout -b feature/mi-feature`
3. Realiza tus cambios
4. Asegúrate de que el código funciona correctamente
5. Haz commit de tus cambios: `git commit -m 'Añadir mi feature'`
6. Push a la rama: `git push origin feature/mi-feature`
7. Abre un Pull Request

## Guía de Estilo

### Bash

- Usa `set -euo pipefail` al inicio de los scripts
- Indentación con 4 espacios
- Variables en MAYÚSCULAS para globales, minúsculas para locales
- Usa `[[` en lugar de `[` para tests
- Documenta las funciones con comentarios
- Sigue el estilo existente en el código

### Commits

- Usa mensajes descriptivos
- Escribe en español o inglés (consistente)
- Primera línea: resumen corto (< 72 caracteres)
- Cuerpo: explicación detallada si es necesario

### Estructura de Módulos

Cada módulo en `lib/` debe:

1. Tener un header con nombre y descripción
2. Usar las variables de colores de `colors.sh`
3. Respetar la configuración del usuario
4. Manejar errores gracefully
5. Soportar el modo dry-run

## Testing

Antes de enviar un PR:

1. Prueba en una instalación limpia de Fedora
2. Verifica que `--check` funciona correctamente
3. Prueba con diferentes configuraciones
4. Asegúrate de que no hay errores de shellcheck

```bash
shellcheck updatelite lib/*.sh
```

## Preguntas

Si tienes preguntas, abre un issue con la etiqueta "question".

## Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo AGPL-3.0.
