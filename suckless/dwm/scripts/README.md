# Editing the dwm bar

`~/suckless` is linked to `~/Mydotfiles/suckless`.

## Appearance

Edit `~/suckless/dwm/config.def.h`. `make` copies this into `config.h`.

- `fonts`: text size. Both fonts currently use `size=10`.
- `baralpha`: background opacity. `0x40` is about 25% opaque;
  `0x80` is about 50%; `OPAQUE` is fully opaque. A compositor is required.
- `barbgcolor`, `barfgcolor`, `baractivecolor`: background, normal text,
  and selected workspace text colors.
- `showtitle`, `showtags`, `showlayout`: visible bar sections.

Apply appearance changes from a terminal in your dwm session:

```sh
cd ~/suckless/dwm
make
make install PREFIX="$HOME/.local"
pkill -HUP -x dwm
```

## Status content

Edit `~/suckless/dwm/scripts/dwm-status.sh`. The `parts` array in `status()`
sets the order of the sections. `sleep 3` controls the status refresh.
Dhaka weather refreshes every 15 minutes in a background process.
Network arrows show actual transferred bytes per second, with K/M meaning
KiB/MiB. They measure current traffic on the default network interface.

The script uses Bash, curl, jq, awk, GNU coreutils, `xsetroot`, and `wpctl`.
The extensionless `dwm-status` symlink keeps the existing session launcher
working. `~/.local/bin/dwm-status` links to it. Changes take effect the next
time the script starts, including at the next login. To restart it immediately
from a terminal in your dwm session:

```sh
pkill -f "^bash $HOME/.local/bin/dwm-status$"
nohup ~/.local/bin/dwm-status >> ~/.local/state/dwm/bar-status.log 2>&1 &
```

Weather API: https://open-meteo.com/en/docs
