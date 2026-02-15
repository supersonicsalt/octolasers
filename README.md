# OCTOLASERS

OCTOLASERS is a pre-alpha Godot 4 puzzle game about firing lasers through a grid to deduce hidden octodots. The current build focuses on sandbox play, a notation sandbox, and a device-couch versus prototype.

## Quick Start
- Open `project.godot` in Godot `4.5` (GL Compatibility renderer).
- Run the main scene: `scenes/menu.tscn`.

## Project Status
- Current version: `0.0.notationUpdate.1` (see `changelog.md`).
- Feature ideas and priorities live in `featureBoard.md`.

## Controls (Current Bindings)
- `interact`: left mouse button (place/fire/paint depending on mode).
- `unInteract`: right mouse button (erase).
- `altInteract`: middle mouse button or `C` (alternate placement in notation mode).
- Menus are fully mouse-driven.

## Scenes and Flow
- `scenes/menu.tscn`: main menu; routes to sandbox, puzzle, options, and versus.
- `scenes/sandboxMenu.tscn`: entry point to classic sandbox and notation sandbox.
- `scenes/sandbox.tscn`: single-board sandbox with lasers + octodot placement.
- `scenes/notationSandbox.tscn`: color-coded laser notation editor (multi-layer).
- `scenes/deviceCouch.tscn`: two-board device couch versus prototype.
- `scenes/playMenu.tscn`: versus menu; routes to device couch and sandbox modes.
- `scenes/puzzleMenu.tscn`: puzzle menu shell.
- `scenes/options.tscn`: options + debug entry.
- `scenes/debug.tscn`: MIDI input debug view and timing graph.
- `scenes/storyMenu.tscn`: locked story stub.

## Core Systems
- Board generation: `scripts/board_interaction.gd` builds a single board; `scripts/board_tiles_device_couch.gd` builds two boards with a configurable offset.
- Laser logic: `scripts/laser_interaction.gd` traces laser paths, draws reflections/absorptions, and logs entry/exit pairs with a letter index.
- Octodot placement: `scripts/octodot_interaction.gd` places/removes dots with spacing rules and clears lasers/logs on change.
- Notation sandbox: `scripts/board_tiles_notation.gd` encodes laser-edge states using a `LaserTile` state machine; `scripts/item_list.gd` handles palette selection, dot/pencil toggles, and laser layer colors.
- UI glue: `scripts/menu.gd`, `scripts/play_menu.gd`, `scripts/puzzle_menu.gd`, `scripts/options.gd`, `scripts/story_menu.gd` handle scene routing.
- Debug: `scripts/debug.gd` opens MIDI devices and logs events; `scripts/color_rect.gd` draws a scrolling timing graph.

## Assets and Data
- Tile sets: `tileset/boardTiles.tres`, `tileset/laserTiles.tres`, `tileset/octodotsTiles.tres`.
- Texture atlases: `textures/atlases/*.png` (board, laser, octodot, arrows).
- Menu textures: `textures/menu/*.png`.
- Localization: `translations/mainTranslation.csv` (keys: `OCTOLASERS`, `VERSUS`, `PUZZLE`, `SANDBOX`, `LEFT`, `RIGHT`, `UP`, `DOWN`, `WIDTH`, `HEIGHT`) plus generated `.translation` resources in `translations/`.

## Export Presets
- Windows Desktop, Android, and Linux presets are defined in `export_presets.cfg`.
- Default export paths are under `../exportedBuilds/octolasers/`.

## Notes
- The notation sandbox and device couch modes are the most active areas of development right now.
- Some menus (story/puzzle) are placeholders and not yet wired to gameplay.
