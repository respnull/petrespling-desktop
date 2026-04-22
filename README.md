# Pet Respling
A Respling on your desktop!

![Banner](https://respnull.github.io/assets/petrespling-banner.png)

## Features
- **Customize** - Customize your respling's colors and accessories!
- **Physics** - Gravity, Velocity and Autopilot bring your respling to life!
- **Caretaking** - Feed, hydrate and let it rest! *(Optional.)*
- **Options Menu** - Right click to tweak settings!

## Compiling
**Linux Requirements**  Git, X11, Cargo/Rust and Qt6 installed.
**Windows Requirements**  Git, a matching toolchain (MSVC for MSVC Qt), Cargo/Rust and Qt6 installed.
**macOS Requirements**  Git, Xcode CLI tools, Cargo/Rust and Qt6 installed. *(macOS support is not tested.)*
After completing the requirements for your OS, run:
```bash
git clone https://github.com/respnull/petrespling-desktop
cd petrespling-desktop
cargo run --release
```
Once complete, you should see a respling on your desktop.

## Licensing
This project's source code is licensed under the Apache License 2.0.

The Respling artwork is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 (CC BY-NC-SA 4.0).
Reference: https://respnull.github.io/assets/thisisarespling.png

This software uses Qt 6, which is licensed under the GNU LGPL v3.
See the QT_LICENSE file for details.
