# 💻 kickstart.linux

Your personal Linux dotfiles and system bootstrapper — easy to install, modular, and minimal.

> 📂 Powered by `Makefile`, this setup automates installing CLI tools, configuring your shell, setting up Neovim, and linking your preferred dotfiles.

---

## 📦 Features

- 🧠 Opinionated but flexible structure
- 🐚 Zsh with [powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- 📝 Neovim installation and config symlinking
- 🔍 fzf fuzzy finder binary install
- 🧠 Git configuration linking
- 🔡 Hack Nerd Font installer
- ⚙️ Minimal dependencies — just `make`, `curl`, and `tar`

---

## 🚀 Quickstart

```bash
git clone https://github.com/yourusername/kickstart.linux.git ~/projects/kickstart.linux
cd ~/projects/kickstart.linux
make
```

That’s it! It will:

- Install Neovim and fzf locally under `bin/`
- Symlink configs like `.zshrc`, `.gitconfig`, and Neovim/Kitty configs
- Install Hack Nerd Font to `~/.local/share/fonts`

---

## 🛠 Commands

| Command       | Description                                  |
|---------------|----------------------------------------------|
| `make`        | Install everything and link all configs      |
| `make install`| Install tools (Neovim, fzf, fonts, etc.)     |
| `make link`   | Symlink all configuration files              |
| `make clean`  | Remove installed tools and temp files        |
| `make path`   | Show local `$PATH` additions (for testing)   |

---

## 📂 Directory Structure

```text
kickstart.linux/
├── Makefile
├── nvim/               # Neovim config folder
├── kitty/              # Kitty terminal config
├── zsh/                # .zshrc and .p10k.zsh
├── git/                # .gitconfig
├── bin/                # (auto-generated) binaries go here
├── temp/               # (auto-generated) temporary downloads
```

---

## 🧹 Cleanup

To remove everything installed by the script:

```bash
make clean
```

This removes:
- Local binaries (`bin/`)
- Temporary files (`temp/`)
- Your Neovim config symlink (`~/.config/nvim`)

---

## 📎 Notes

- No global system changes are made unless `zsh` is not installed or not the default shell (then it prompts `sudo`).
- Add the following to your shell profile to test the installed binaries:

```bash
export PATH="$HOME/projects/kickstart.linux/bin/nvim/bin:$HOME/projects/kickstart.linux/bin/fzf:$PATH"
```

---

## 📜 License

MIT — use it freely, hack it wildly.


