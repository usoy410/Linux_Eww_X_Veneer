# RainMeter Eww Widgets

`ClockRainmeter` and `CavaVisualizer` widgets.

## Sample

![Sample widget screenshot](./Sample.png)

## Contents

### 1. ClockRainmeter

A minimalist clock widget showing the day, date, and time.

- `clock.yuck`: Widget and window definitions.
- `variables.yuck`: Time/day/date polls.
- `style.scss`: Required CSS styles.

### 2. CavaVisualizer

A simple audio visualizer using `cava`.

- `cava.yuck`: Widget and window definitions.
- `variables.yuck`: Cava listen variable.
- `scripts/cava.sh`: Script that processes `cava` output.
- `style.scss`: Required CSS styles.

## Quick Setup (Recommended)

Run the setup script from this repository root:

```bash
git clone https://github.com/usoy410/Linux_Eww_Rainmeter.git
cd Linux_Eww_Rainmeter
chmod +x ./scripts/setup.sh ./scripts/run.sh
./scripts/setup.sh
```

What setup does:

1. Installs required dependencies (`eww`, `cava`) using your system package manager (apt/pacman/dnf/zypper).
2. Creates an Eww config at `~/.config/eww`.
3. Copies both widget folders there.
4. Generates `eww.yuck` and `eww.scss` that include/import both widgets.

Then start both widgets:

```bash
./scripts/run.sh
```

## Manual Run Commands

If you prefer running manually:

```bash
eww --config ~/.config/eww daemon
eww --config ~/.config/eww open clock
eww --config ~/.config/eww open visualizer_window
```

To stop them:

```bash
eww --config ~/.config/eww close clock
eww --config ~/.config/eww close visualizer_window
```

## Autostart on Login (Optional)

If you want these widgets to start automatically when you log in, pick one approach below.
Make sure to change the path if you did not clone in the home to this repository's scripts/run.sh in startup entries.

### 1. Hyprland

Add this line to `~/.config/hypr/hyprland.conf`:

```ini
exec-once = /bin/sh -c '~/Linux_Eww_Rainmeter/scripts/run.sh'
```

### 2. Niri

Add this in `~/.config/niri/config.kdl`:

```kdl
spawn-at-startup "/bin/sh" "-c" "~/Linux_Eww_Rainmeter/scripts/run.sh"
```

### 3. Other Desktop/WMs

Just add it to whatever Window manager you have in its start up.

## Dependency Note

If automatic dependency installation cannot find `eww` on your distro repositories, install `eww` manually and re-run setup.

## References

- Eww official docs: https://elkowar.github.io/eww/
- Eww GitHub repository: https://github.com/elkowar/eww
