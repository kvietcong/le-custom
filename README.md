# linux-things
Just a repo to store linux related things that range from config files
to just good things to know

## Nice things to know

- Discord requires pulseaudio to work
  - Most machines from what I researched have ALSA it is rec. to install
  `pulseaudio` and `pulseaudio-alsa`
  - I also used `pulsemixer` to mix the sounds

- When using lightdm, it seems to also require the `lightdm-gtk-greeter`

- You cannot partition nested partitions (Useful when splitting drive
between Windows and Linux)
  - Instead partition the uppermost parent drive

- Use `cfdisk` to partition rather than `fdisk`
  - cfdisk is a bit easier to use and understand (especially for noobs like me)

- If stranded in an Arch install without Ethernet, use `iwctl`
  - To ensure your wifi adapter isn't blocked use `rfkill unblock all`
    - If you don't want to unblock all, I believe it can be replaced with `wifi`
  - If you don't know your wifi adapter's name you can use `device list` after getting
  into the `iwctl` shell
  - To actually connect, go into `iwctl` and type `station <Device Name> connect <Network Name>`
    - To scan for networks you can use `station <Device Name> scan`
    - The password will be prompted from you if needed

- `lsblk` is a lot cleaner to see partitions compared to `fsdisk -l`

- I use Arch btw
