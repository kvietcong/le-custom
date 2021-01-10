## Things I use

- Distributions
  - [**I use it btw 😢**](https://archlinux.org/)
  - Manjaro
  - Ubuntu

- 🪟 Window Managers / 🖥 Desktop Environments
  - **AwesomeWM**
  - KDE
  - GNOME
  - XFCE
  - MATE
  - LxQt

- Programs
  - Rofi: App launcher/Command Runner
  - Redshift: Color temperature for night time (f.lux but for Linux)
  - Solaar: Logitech Device Support
  - LXAppearance: Lighweight GTK Configurator
  - OpenTabletDriver: Pen Tablet Driver support (for osu! and art 😃)
  - Thunar: Graphical file manager
  - qBittorrent: GUI torrent client
  - kitty: Pretty cool terminal with good display capabilities
  - Samba: Nice SMB file sharing service
  - Flameshot: Powerful screen-shot tool
  - NeoVim: Great text editing
  - CopyQ: Clipboard manager
  - Obsidian: Great note taking app

## Nice things to know

- Discord requires pulseaudio to work
  - Most machines from what I researched have ALSA it is recommended to install
  `pulseaudio` and `pulseaudio-alsa`
  - I also used `pulsemixer` to mix the sounds
  - `pavucontrol` is a nice GUI for pulseaudio

- When using lightdm, it also requires some type of greeter like `lightdm-gtk-greeter`
  or `lightdm-webkit2-greeter`

- If you use a custom kernel (i.e. `linux-zen`) remember to use `nvidia-dkms` rather
  than just `nvidia`!!! Also get `nvidia-utils` and `nvidia-settings` while your at it

- You cannot partition nested partitions (Useful when splitting drive
  between Windows and Linux)
  - Instead partition the lowermost parent drive

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

- `pacman -Rs $(pacman -Qtdq)` Removes all unneeded* dependencies. `pacman -Rs <package>` removes
  the package and it's unneeded dependencies
  - Be sure to check the list using just `pacman -Qtdq`
  - `pacman -Qe` lists the packages that you have (usually) installed manually

- Using the `alt` keys as a Window Manager's Mod keys is so much more ergonomic for me.
  You can use it on both sides and it strains a lot less than the Super (Windows) Key

- Great Xresources color theme maker can be found [here](https://github.com/deviantfero/wpgtk)
  - Xresources (`.Xresources`) is a file in the `~` directory that is a common place that
    programs "pick" their colors from

- Easy way to find window class: `xprop WM_CLASS` in the console lets you click on any window
  and retrieve's its window class

- `.xinitrc` and `.xprofile` are great places for autostart stuff

- Forget to do `sudo` on a command? Just type `sudo !!` after your mistake. `!!` repeats the
  immediately preceeding command

- To allow a script (usually `.sh` files) to execute, you must give them the proper flags with
  `chmod u+x <File Name>`

- When using kitty, leave `TERM=xterm-kitty`. Changing this seems to make things go wack

- You can sync Linux and Windows time with `timedatectl set-local-rtc 1 --adjust-system-clock` on Linux

- Fonts are important! If you see a lot of missing symbols within your linux install remember to get
  font packages that support the symbols you'll be using.

- `picom` seems to have VSync enabled by default. Make sure you disable that if you have a dual
  monitor setup. (Or launch on a per monitor basis)

- `react-scripts` seems to not work natively on Arch. You can fix this by doing `npm i -g react-scripts`
  but that is seems very jank b/c it requires sudo. You can also redirect the react-scripts to go
  into `./node_modules/react-scripts/bin/react-scripts.js <COMMAND-NAME>`. I will need to research
  why this behavior exists b/c it seems common given the stack overflow posts. No one really ever solves
  the problem though

- Remember to setup your new SSH keys for any git services you use.
  ([Github](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account))

- `pgrep` is to retrieve the process ID of a program. REALLY useful to run programs dependent on
  if it is already running or not

- If you want to use the settings sync in VSCode on Arch, you should install `gnome-keyring`
  for secret storing

- `xev` is a beautiful command that outputs any button you press, which you can then map using
  some type of key manager

- `xset -q | grep "Caps Lock:[ ]\+on" -c && xdotool key Caps_Lock; setxkbmap -option caps:escape`
  - This shell command will disable your Caps Lock and then remap it to Escape
  - This works wonders with things like vim 😆

- `rmmod hid_uclogic` and `echo "blacklist echo "blacklist hid_uclogic" | sudo tee -a /etc/modprobe.d/blacklist.conf`
  - Disable default drivers for XP-Pen Tablets (To work with Open Tablet Driver)

- Want transparent and blurry discord? Check out [Glasscord](https://github.com/AryToNeX/Glasscord)!
  - A personal favorite theme that takes advantage of it is [Nord Glasscord](https://github.com/YottaGitHub/Nord-Glasscord)

- You can edit your `.desktop` file to make it so it opens a specific terminal. (Used to get Thunar
  to always open with kitty)

- Use GNU Stow to easily manage all your dotfiles!

- Use [NoiseTorch](https://github.com/lawl/NoiseTorch) to automagically remove background
  noise from your microphone. It actually is insane how well it works
  - Want a better way? Load it directly into your pulseaudio configuration with a ladspa plugin
    from [`noise-suppression-for-voice`](https://github.com/werman/noise-suppression-for-voice)

- Steam for some reason keeps your screen awake when you use an external
  storage solution for your library

- Documentation is key!

- I use Arch btw XD
