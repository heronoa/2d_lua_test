## Overview

This repository contains the source code for an 2d RPG game built using the LÖVE framework.

## Getting Started

### Prerequisites

- [LÖVE](https://love2d.org/) 11.3 or higher

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/heronoa/2d_lua_test.git
   cd isometric_rpg
   ```

2. Run the game:
   ```sh
   love .
   ```

3. Compile game (Optional):
    ```sh
    sh compile.sh
    ```

## Directory Structure

- **.loveignore**: Specifies files and directories to exclude when creating a .love file.
- **main.lua**: The main entry point of the game.
- **conf.lua**: Configuration file for LÖVE settings.
- **README.md**: This file.
- **docs/**: Documentation files.
- **src/**: Source code of the game.
  - **core/**: Core modules including game state management, configuration, event system, and utility functions.
  - **game/**: Game-specific modules including entities, world generation, and scenes.
  - **ui/**: User interface components including HUD, menus, and widgets.
- **assets/**: Game assets including graphics, audio, and fonts.
- **lib/**: External libraries used in the project.
- **tests/**: Unit tests for the project.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [LÖVE](https://love2d.org/)
- [Bump](https://github.com/kikito/bump.lua)
