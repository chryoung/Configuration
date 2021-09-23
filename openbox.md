## Openbox

### Install openbox

`sudo pacman -S openbox`

### Configuration

#### Auto-generated application menu

```sh
sudo pacman -S archlinux-xdg-menu obconf
cp -R /etc/xdg/openbox ~/.config/openbox
```

Open `~/.config/openbox/menu.xml`, add the following entry to the `root-menu`:

```xml
  <menu id="applications" label="Applications" execute="xdg_menu --format openbox3-pipe --root-menu /etc/xdg/menus/arch-applications.menu" />
```

And the whole `root-menu` may look like this:

```xml
<menu id="root-menu" label="Openbox 3">
  <menu id="applications" label="Applications" execute="xdg_menu --format openbox3-pipe --root-menu /etc/xdg/menus/arch-applications.menu" />
  <separator label="System" />
  <menu id="system-menu"/>
  <separator />
  <item label="Log Out">
    <action name="Exit">
      <prompt>yes</prompt>
    </action>
  </item>
</menu>
```

## Theme

```sh
sudo pacman -S obconf
```

Launch obconf to select theme.

## Dock

### tint2

#### Install

`sudo pacman -S tint2`

#### Autostart

- Using Xorg: Add `tint2 &` to the ~/.xinitrc before the exec of the window manager.
- Using Openbox: Edit `~/.config/openbox/autostart`, add `tint2 &` at the end of the file.

### Cairo-dock

#### Install

`sudo pacman -S cairo-dock`

#### Autorun for Openbox

Edit `~/.config/openbox/autostart`, add `cairo-dock &` at the end of the file.

## Wallpaper

### Nitrogen

#### Install

`sudo pacman -S nitrogen`

#### Usage

- Select wallpapaer: `nitrogen /path/to/image/directory/`

- Autostart: add `nitrogen --restore &` to `~/.config/openbox/autostart`

## GTK

### Theme

#### Install

Put the theme folder into `/usr/share/themes/`.

#### Usage

- GTK+ 2:

```
# Add to ~/.gtkrc-2.0
gtk-icon-theme-name = "Adwaita"
gtk-theme-name = "Adwaita"
gtk-font-name = "DejaVu Sans 11"
```

- GTK+ 3:

```
# Add to ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-icon-theme-name = Adwaita
gtk-theme-name = Adwaita
gtk-font-name = DejaVu Sans 11
```

## Numix theme (For Arch disto)

Install the artifacts/numix* by the following order:

Install command: `sudo pacman -U package_name.zst`

1. numix-gtk-theme-git-2.6.7.r55.ad4b345-1-any.pkg.tar.zst
1. numix-icon-theme-git-21.04.14.r7.gd80083644-1-any.pkg.tar.zst
1. numix-square-icon-theme-21.09.19-1-any.pkg.tar.zst

### GTK settings

- GTK+ 2:

```
# Add to ~/.gtkrc-2.0
gtk-icon-theme-name = "Numix-Square"
gtk-theme-name = "Numix"
```

- GTK+ 3:

```
# Add to ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-icon-theme-name=Numix-Square
gtk-theme-name=Numix
```

## urxvt

Add the following lines to `~/.Xdefaults`

```
!-------------------------------------------------------------------------------
! Xft settings
!-------------------------------------------------------------------------------
Xft.dpi:                    96
Xft.antialias:              true
Xft.rgba:                   rgb
Xft.hinting:                true
Xft.hintstyle:              hintslight

!-------------------------------------------------------------------------------
! URxvt settings
! Colours lifted from Solarized (http://ethanschoonover.com/solarized)
! More info at:
! http://pod.tst.eu/http://cvs.schmorp.de/rxvt-unicode/doc/rxvt.1.pod
!-------------------------------------------------------------------------------

URxvt.depth:                32
URxvt.geometry:             90x30
URxvt.transparent:          false
URxvt.fading:               0
! URxvt.urgentOnBell:         true
! URxvt.visualBell:           true
URxvt.loginShell:           true
URxvt.saveLines:            50
URxvt.internalBorder:       3
URxvt.lineSpace:            0

! Fonts
URxvt.allow_bold:           false
/* URxvt.font:                 -*-terminus-medium-r-normal-*-12-120-72-72-c-60-iso8859-1 */
URxvt*font: xft:Source Code Pro:pixelsize=14
URxvt*boldFont: xft:Source Code Pro:pixelsize=14

! Fix font space
URxvt*letterSpace: -1

! Scrollbar
URxvt.scrollStyle:          rxvt
URxvt.scrollBar:            false

! Perl extensions
URxvt.perl-ext-common:      default,matcher
URxvt.matcher.button:       1
URxvt.urlLauncher:          firefox

! Cursor
URxvt.cursorBlink:          true
URxvt.cursorColor:          #657b83
URxvt.cursorUnderline:      false

! Pointer
URxvt.pointerBlank:         true

! Theme solarized
!!Source http://github.com/altercation/solarized

*background: #002b36
*foreground: #657b83

!!*fading: 40

*fadeColor: #002b36
*cursorColor: #93a1a1
*pointerColorBackground: #586e75
*pointerColorForeground: #93a1a1

!! black dark/light
*color0: #073642
*color8: #002b36

!! red dark/light
*color1: #dc322f
*color9: #cb4b16

!! green dark/light
*color2: #859900
*color10: #586e75

!! yellow dark/light
*color3: #b58900
*color11: #657b83

!! blue dark/light
*color4: #268bd2
*color12: #839496

!! magenta dark/light
*color5: #d33682
*color13: #6c71c4

!! cyan dark/light
*color6: #2aa198
*color14: #93a1a1

!! white dark/light
*color7: #eee8d5
*color15: #fdf6e3
```
