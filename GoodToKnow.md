## Useful programs I use

- Rofi: DMenu alternative. App launcher/Command Runner
- Redshift: Blue light limiter for night time (f.lux but linux)
- Ranger: Terminal File Explorer
- Solaar: Logitech Device Support
- Font Manager: Good way to visualize/manage fonts
- LXAppearance: Lighweight GTK Configurator
- PavuControl: Nice Pulseaudio GUI
- OpenTabletDriver: Pen Tablet Driver support (for osu! and art 😃)

## Nice things to know

- Discord requires pulseaudio to work
  - Most machines from what I researched have ALSA it is rec. to install
  `pulseaudio` and `pulseaudio-alsa`
  - I also used `pulsemixer` to mix the sounds

- When using lightdm, it also requires some type of greeter like `lightdm-gtk-greeter`
  or `lightdm-webkit2-greeter`

- You cannot partition nested partitions (Useful when splitting drive
  between Windows and Linux)
  - Instead partition the uppermost parent drive

- Use `cfdisk` to partition rather than `fdisk`
  - cfdisk is a bit easier to use and understand (especially for noobs like me)

- If stranded in an Arch install without Ethernet, use `iwctl`
  - To ensure your wifi adapter isn't blocked use `rfkill unblock all`
    - If you don't want to unblock `all`, I believe it can be replaced with `wifi`
  - If you don't know your wifi adapter's name you can use `device list` after getting
  into the `iwctl` shell
  - To actually connect, go into `iwctl` and type `station <Device Name> connect <Network Name>`
    - To scan for networks you can use `station <Device Name> scan`
    - The password will be prompted from you if needed

- `lsblk` is a lot cleaner to see partitions compared to `fsdisk -l`

- To remove mouse acceleration, configure your xorg files according to
  [this](https://wiki.archlinux.org/index.php/Mouse_acceleration) Arch wiki page
  - It seems that the first option disables acceleration but also is a bit slower
  than Windows. Use the second option with `libinput` for a more Window's like sensitivity

- `pacman -Rs $(pacman -Qtdq)` Removes all uneeded* dependencies. `pacman -Rs <package>` removes
  the package and it's uneeded dependencies
  - Be sure to check the list using just `pacman -Qtdq`

- Using the `alt` keys as a Window Manager's Mod keys is so much more ergonomic for me.
  You can use it on both sides and it strains a lot less than the Super (Windows) Key

- Great Xresources color theme maker can be found [here](https://github.com/deviantfero/wpgtk)
  - Xresources (`.Xresources`) is a file in the `~` directory that is a common place that
    programs "pick" their colors from

- Easy way to find window class: `xprop WM_CLASS` in the console lets you click on any window
  and retrieve's its window class

- `.xinitrc` and `.xprofile` are great places for startup scripting

- Forget to do `sudo` on a command? Just type `sudo !!` after your mistake. `!!` repeats the
  immediately preceeding command

- To allow a script (usually `.sh` files) to execute, you must give them the proper flags with
  `chmod u+x <File Name>`

- Adding `export TERM=<Value>` to your `.bashrc` or `.zshrc` seems to block mouse clicking
  (confirmed in vim) (To solve)

- You can sync Linux and Windows time with `timedatectl set-local-rtc 1 --adjust-system-clock` on Linux

- Fonts are important! If you see a lot of missing symbols within your linux install remember to get
  font packages that support the symbols you'll be using.

- `picom` seems to have VSync enabled by default. Make sure you disable that if you have a dual
  monitor setup. (Or launch on a per monitor basis)

- To use run React Scripts on Linux, it seems you have to install the module globally using
  `npm install -g react-scripts`. For me, this required sudo so I am fairly sure this is jank 😂

- Documentation is key!

- I use Arch btw XD
