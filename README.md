<p align="center">
    <img src="content/logo.png" width="600" align="center"/>
</p>
<p align="center">Logo by froggo.8174 on Discord!</p>

---

This is the official "FNF: Fireball Engine" Repository. Fireball Engine is a barebones Friday Night Funkin' Modding Engine designed for easy to use soft-modding without containing the base game, only avalible for Desktop targets.

Fireball Engine is in active development! Join our Discord Server [here](https://discord.gg/F2BXD23QWF).

## Why does this exist?
I believed there should be a heavily advanced yet extremely easy to use FNF Engine, something optimized for multiple mods while being optimal for full control and creativity. No FNF Engines (that I'm aware of) implement this in a way that I'm happy with. My goal is to make an Engine that isn't clunky, and is easy to use immediately.

## Notice
Fireball Engine is not affiliated with "The Funkin' Crew Inc." or "Friday Night Funkin'". No assets or source code from the mentioned names are driectly contained within this project. You must have a desktop copy of "Friday Night Funkin'" for Fireball Engine to function proper.

**Zero code or assets were made with Generative AI, yuck.**

### License
Two seperate licenses are contained in this repository. The source code without its assets fall under the [Apache 2.0 License](licenses/APACHE_LICENSE), but other content and/or assets may fall under different licenses. For more information, read the [LICENSE](LICENSE).

To contribute to this project, you must have read and agreed to the applicable licenses as it affects you as a contributor. Especially if that contribution is assets.

## How to build
Install Haxe 4.3.7, and follow the [HaxeFlixel Install Guide](https://haxeflixel.com/documentation/install-haxeflixel/). Then, run the following commands to install all the necessary libraries:

```bash
haxelib install hxvlc
haxelib install flixel-animate
haxelib install hxdiscord_rpc
```

You can then compile and test with either `lime test windows`, `lime test linux`, or `lime test mac` depending on your host device or target. **MacOS is untested**.

### Linux Users
Extra actions are required for certain libraries to function properly with this project.

#### Arch Users
Run these commands under `sudo`:

```bash
pacman -S vlc
```

#### Debian/Ubuntu Users
Run these commands under `sudo`:

```bash
apt-get install vlc libvlc-dev libvlccore-dev vlc-bin
```

### Pull Requests
Do not submit AI Generated code or assets in a PR, all code must be human written and tested before submitting. Code must be formatted similarly with the rest of the project, and any assets included in the PR must be created by you or have the rights to it.