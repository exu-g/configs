This host requires additional considerations, as it is using a 1440p display.

The following parts are modified:

- Polybar (.config/polybar/i3config.ini)
- Xresources (.Xresources)
- X11 (/etc/X11/xorg.conf.d/ _new files_)

## Calculate Monitor size for desired DPI

To get the exact monitor size xorg wants for a target dpi, execute this command.

```sh
xrandr --dpi [DPI]
```

Querying the set dpi now yields the exact monitor size you'd want to set.

```
$> xdpyinfo | grep -B 2 resolution
screen #0:
  dimensions:    2560x1440 pixels (541x304 millimeters)
  resolution:    120x120 dots per inch
```
