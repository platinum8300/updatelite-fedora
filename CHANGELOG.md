# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2024-02-03

### Añadido

- Versión inicial de updateLITE para Fedora
- Actualización del sistema con DNF5
- Actualización de firmware con fwupdmgr
- Actualización de aplicaciones Flatpak
- Información de repositorios COPR activos
- Limpieza de contenedores Podman
- Optimización SSD con fstrim
- Limpieza del sistema:
  - Paquetes huérfanos
  - Cache de DNF5
  - Logs del sistema
  - Archivos temporales
  - Gestión inteligente de kernels
- Verificación de servicios fallidos
- Detección de reinicio necesario
- Snapshots BTRFS automáticos
- Modo dry-run (--check)
- Sistema de configuración modular
- Integración con Bash, Zsh y Fish
- Frases motivacionales
- Instalador y desinstalador
