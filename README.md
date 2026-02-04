<p align="center">
  <img src="cover.png" alt="updateLITE Fedora Edition" width="600">
</p>

# updateLITE Fedora Edition

System maintenance tool for **Fedora Linux**

A modular, user-friendly script that handles system updates, cleanup, and maintenance in one command.

## Features

- **Unified Updates**: DNF5, COPR, Flatpak, Podman, and Firmware
- **Smart Cleanup**: Orphan packages, cache, and journal management
- **Service Monitoring**: Detect failed systemd services
- **Reboot Detection**: Know when critical packages require a restart
- **Modular Design**: Enable only what you need
- **Multi-Shell Support**: Fish, Bash, and Zsh integration

## Quick Install

```bash
git clone https://github.com/platinum8300/updatelite-fedora.git
cd updatelite-fedora
./install.sh
```

## Usage

```bash
# Run full system maintenance
updatelite

# Show all options
updatelite --help
```

## Configuration

Configuration file location: `~/.config/updatelite/config`

Create default config:
```bash
updatelite --create-config
```

### Key Options

| Option | Default | Description |
|--------|---------|-------------|
| `ENABLE_DNF` | true | Update system packages via DNF5 |
| `ENABLE_COPR` | true | Show active COPR repositories |
| `ENABLE_FLATPAK` | true | Update Flatpak apps |
| `ENABLE_PODMAN` | false | Clean Podman containers |
| `ENABLE_FIRMWARE` | true | Update firmware via fwupd |
| `CLEANUP_ORPHANS` | true | Remove orphan packages |
| `CLEANUP_CACHE` | true | Clean package cache |
| `JOURNAL_VACUUM_DAYS` | 7 | Keep journal for N days |

See [config/updatelite.conf.example](config/updatelite.conf.example) for all options.

## Requirements

**Required:**
- Fedora Linux (40+)
- Bash 4.0+
- dnf5
- sudo

**Recommended:**
- flatpak (for Flatpak support)
- fwupd (for firmware updates)

## CLI Options

```
Usage: updatelite [OPTIONS]

Options:
  --create-config    Create default configuration file
  -v, --version      Show version information
  -h, --help         Show help message
```

## Directory Structure

```
~/.local/bin/updatelite           # Main script
~/.local/share/updatelite/lib/    # Library modules
~/.config/updatelite/config       # Configuration
```

## Uninstall

```bash
./uninstall.sh
```

Or manually:
```bash
rm ~/.local/bin/updatelite
rm -rf ~/.local/share/updatelite
rm -rf ~/.config/updatelite  # Optional: keeps your config
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the **GNU Affero General Public License v3.0** (AGPL-3.0).

See [LICENSE](LICENSE) for the full text.

## Acknowledgments

- The Fedora community
- Contributors and users who provide feedback
