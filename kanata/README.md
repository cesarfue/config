# Kanata — Space Navigation Layer

Cross-platform keyboard remapping (Linux + macOS) using [Kanata](https://github.com/jtroo/kanata).

## What it does

Hold **Space** and use vim-style keys to navigate:

| Combo         | Result     |
|---------------|------------|
| Space + h     | Left       |
| Space + j     | Down       |
| Space + k     | Up         |
| Space + l     | Right      |

Tapping Space on its own still types a space.

**Toggle:** tap **Right Alt** to disable/enable the space layer (useful when switching to a split keyboard).

## Installation

### Linux

```bash
# Option 1: cargo
cargo install kanata

# Option 2: download binary from GitHub releases
# https://github.com/jtroo/kanata/releases
```

You'll need access to `/dev/uinput`. Either run as root or add a udev rule:

```bash
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | \
  sudo tee /etc/udev/rules.d/99-uinput.rules

# Reload and reboot
sudo udevadm control --reload-rules && sudo udevadm trigger
# Then log out and back in (or reboot)
```

### macOS

```bash
brew install kanata
```

Kanata needs the Input Monitoring permission. macOS will prompt you on first run.

## Running

```bash
kanata -c ~/.config/kanata/kanata.kbd
```

To run in the background:

```bash
kanata -c ~/.config/kanata/kanata.kbd &
```

To start on boot, create a systemd service (Linux) or a launchd plist (macOS). See the [Kanata docs](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md) for examples.

## Config guide

### Key concepts

The config is in `kanata.kbd` and uses S-expressions (lisp-like syntax).

- **`defsrc`** — Lists physical keys to intercept. Keys not listed pass through unchanged.
- **`deflayer`** — Defines what each key does on a given layer. Must have the same number of entries as `defsrc`, in the same order.
- **`defalias`** — Named reusable actions.
- **`tap-hold <tap-timeout> <hold-timeout> <tap-action> <hold-action>`** — Tap a key for one action, hold it for another.
- **`layer-toggle <layer>`** — Activate a layer while a key is held.
- **`layer-switch <layer>`** — Permanently switch to a layer (until another switch).

### Adding keys to the navigation layer

To add a new key to the nav layer, you need to:

1. Add the key to `defsrc`
2. Add its behavior in **every** `deflayer` (same position)

Example — add `u` for Page Up and `d` for Page Down:

```lisp
(defsrc
  spc h j k l u    d    ralt
)

(deflayer base
  @spc h j k l u    d    @dis
)

(deflayer nav
  spc  left down up rght pgup pgdn ralt
)

(deflayer disabled
  spc  h    j    k  l    u    d    @ena
)
```

### Common key names

| Key name | Description    |
|----------|----------------|
| `left`   | Left arrow     |
| `rght`   | Right arrow    |
| `up`     | Up arrow       |
| `down`   | Down arrow     |
| `pgup`   | Page Up        |
| `pgdn`   | Page Down      |
| `home`   | Home           |
| `end`    | End            |
| `esc`    | Escape         |
| `bspc`   | Backspace      |
| `del`    | Delete         |
| `ret`    | Enter/Return   |
| `tab`    | Tab            |

Full list: [Kanata key names](https://github.com/jtroo/kanata/blob/main/docs/key-names.md)

### Adding a new layer

1. Define a new alias for the layer trigger (pick a key to hold):

```lisp
(defalias
  ;; ... existing aliases ...

  ;; Tab: tap = tab, hold = activate symbols layer
  sym (tap-hold 200 200 tab (layer-toggle symbols))
)
```

2. Add `tab` to `defsrc` and all existing `deflayer` blocks.

3. Create the new layer:

```lisp
(deflayer symbols
  spc  h    j    k  l    tab  ralt
  ;; ^ fill in all defsrc positions, remap what you need
)
```

### Changing the toggle key

The toggle is on `ralt` (Right Alt). To change it, replace `ralt` in `defsrc` and all `deflayer` blocks with another key, and update the `dis`/`ena` aliases. For example, to use `rctl` (Right Control):

```lisp
(defsrc
  spc h j k l rctl
)

(defalias
  dis (tap-hold 200 200 (layer-switch disabled) rctl)
  ena (tap-hold 200 200 (layer-switch base) rctl)
)

;; Update every deflayer to have rctl in the last position instead of ralt
```

### Modifier passthrough

The nav layer works with modifiers. For example:

- **Shift + Space + h** → Shift + Left (select text)
- **Ctrl + Space + l** → Ctrl + Right (jump word right)

This works out of the box because `process-unmapped-keys yes` passes modifiers through.

### Tuning tap-hold timing

If space triggers navigation when you meant to type a space (or vice versa), adjust the timeout:

```lisp
;; (tap-hold <tap-timeout-ms> <hold-timeout-ms> <tap> <hold>)
spc (tap-hold 150 150 spc (layer-toggle nav))  ;; faster — more responsive tap
spc (tap-hold 250 250 spc (layer-toggle nav))  ;; slower — more forgiving hold
```
