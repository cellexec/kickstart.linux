# ⚠️ DEPRECATED

> **This repo has been superseded by [cellexec/dotfiles](https://github.com/cellexec/dotfiles)** — a unified, stow-based dotfile repo that supports omarchy, ubuntu server, and WSL from a single source of truth.
>
> This repo is kept for reference only and will no longer be maintained.

---

# 💻 kickstart.linux

**kickstart.linux** is a lightweight, opinionated, and modular **dotfile and system bootstrapping solution** for Linux. It uses a `Makefile` to automate the installation of essential CLI tools, configure your shell, set up Neovim, and symlink your personal dotfiles, ensuring a consistent development environment across your machines.

-----

## ✨ Features

  * **Modular & Minimal:** Focused on core tools with a clean, easy-to-understand structure.
  * **Automated Setup:** Installs CLI applications like Neovim, fzf, Flux CLI, k9s, and Kind.
  * **Shell Configuration:** Sets up Zsh with the popular Powerlevel10k theme.
  * **Dotfile Management:** Symlinks essential configuration files for Git, Neovim, Kitty, and Zsh.
  * **Font Installation:** Includes automatic installation of the Hack Nerd Font for a rich terminal experience.
  * **Local Installation:** Tools are installed to a local `bin/` directory, minimizing system-wide changes.

-----

## 🚀 Get Started

Clone the repository and run `make`:

```bash
git clone https://github.com/yourusername/kickstart.linux.git ~/projects/kickstart.linux
cd ~/projects/kickstart.linux
make
```

This command will:

  * Install all specified CLI tools (Neovim, fzf, Flux, k9s, Kind) into `~/projects/kickstart.linux/bin/`.
  * Symlink your configuration files (e.g., `.zshrc`, `.gitconfig`, Neovim, Kitty) to their respective home directories.
  * Install the Hack Nerd Font.

-----

## 🛠 Usage

Here are the primary `make` commands:

| Command        | Description                                       |
| :------------- | :------------------------------------------------ |
| `make`         | Installs all tools and symlinks all configurations. |
| `make install` | Installs all binaries and fonts.                  |
| `make link`    | Symlinks all configuration files.                 |
| `make clean`   | Removes all installed tools and temporary files.   |
| `make path`    | Displays the recommended `$PATH` additions.       |

-----

## 📂 Structure

```
kickstart.linux/
├── Makefile            # The core automation script
├── nvim/               # Neovim configuration files
├── kitty/              # Kitty terminal configuration
├── zsh/                # Zsh (.zshrc) and Powerlevel10k (.p10k.zsh) configs
├── git/                # Git global configuration (.gitconfig)
├── bin/                # (Auto-generated) Location for installed binaries
└── temp/               # (Auto-generated) Temporary download directory
```

-----

## ♻️ Cleanup

To revert all changes made by this kickstart:

```bash
make clean
```

This command removes all locally installed binaries, temporary files, and dotfile symlinks.

-----

## 📝 Notes

  * This script primarily performs local installations. The only system-wide changes occur if `zsh` is not installed or not set as your default shell, which will prompt for `sudo`.
  * Ensure `make`, `curl`, `tar`, and `unzip` are available on your system before running.

-----

## 📜 License

This project is licensed under the MIT License. Feel free to use, modify, and distribute.
