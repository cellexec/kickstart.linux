#  ============================================
#  ===         💻 Kickstart.Linux           ===
#  ============================================

# 📁 Base Directories
KICKSTART_DIR := $(HOME)/projects/kickstart.linux
BIN_DIR := $(KICKSTART_DIR)/bin
TEMP_DIR := $(KICKSTART_DIR)/temp

# 📦 Neovim
NVIM_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
NVIM_TEMP_EXTRACT := $(TEMP_DIR)/nvim
NVIM_TEMP_ARCHIVE := $(TEMP_DIR)/nvim.tar.gz
NVIM_TARGET_DIR := $(BIN_DIR)/nvim
NVIM_BINARY := $(NVIM_TARGET_DIR)/bin/nvim

# 📦 Tmux
TPM_URL := https://github.com/tmux-plugins/tpm
TPM_TARGET := ~/.tmux/plugins/tpm
TMUX_FILE := $(HOME)/.tmux.conf
TMUX_SOURCE := $(KICKSTART_DIR)/tmux/.tmux.conf

# 📦 fzf
FZF_VERSION := 0.61.2
FZF_TAG := v$(FZF_VERSION)
FZF_FILE := fzf-$(FZF_VERSION)-linux_amd64.tar.gz
FZF_URL := https://github.com/junegunn/fzf/releases/download/$(FZF_TAG)/$(FZF_FILE)
FZF_TEMP_EXTRACT := $(TEMP_DIR)/fzf
FZF_TARGET_DIR := $(BIN_DIR)/fzf
FZF_BINARY := $(FZF_TARGET_DIR)/fzf

# 📦 k9s
K9S_VERSION := 0.50.4
K9S_FILE := k9s_Linux_amd64.tar.gz
K9S_URL := https://github.com/derailed/k9s/releases/download/v$(K9S_VERSION)/$(K9S_FILE)
K9S_TEMP_EXTRACT := $(TEMP_DIR)/k9s
K9S_TARGET_DIR := $(BIN_DIR)/k9s
K9S_BINARY := $(K9S_TARGET_DIR)/k9s

# ⚙️ Git
GITCONFIG_FILE := $(HOME)/.gitconfig
GITCONFIG_SOURCE := $(KICKSTART_DIR)/git/.gitconfig

# 🐚 Zsh
ZSHRC_FILE := $(HOME)/.zshrc
ZSHRC_SOURCE := $(KICKSTART_DIR)/zsh/.zshrc
P10K_FILE := $(HOME)/.p10k.zsh
P10K_SOURCE := $(KICKSTART_DIR)/zsh/.p10k.zsh

# 📦 Flux CLI
FLUX_VERSION := 2.2.3
FLUX_FILE := flux_$(FLUX_VERSION)_linux_amd64.tar.gz
FLUX_URL := https://github.com/fluxcd/flux2/releases/download/v$(FLUX_VERSION)/$(FLUX_FILE)
FLUX_TEMP_EXTRACT := $(TEMP_DIR)/flux
FLUX_TARGET_DIR := $(BIN_DIR)/flux
FLUX_BINARY := $(FLUX_TARGET_DIR)/flux

# 🔡 Fonts
FONTS_DIR := $(HOME)/.local/share/fonts
HACK_FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
HACK_FONT_ZIP := $(TEMP_DIR)/Hack.zip

.PHONY: all install install-nvim install-fzf install-gitconfig install-zsh install-fonts clean link path

all: install link

install: install-nvim install-fzf install-tmux install-gitconfig install-zsh install-fonts install-flux install-k9s


install-nvim:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===         Installing Neovim     ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
	@curl -L $(NVIM_URL) -o $(NVIM_TEMP_ARCHIVE)
	@rm -rf $(NVIM_TEMP_EXTRACT) $(NVIM_TARGET_DIR)
	@mkdir -p $(NVIM_TEMP_EXTRACT)
	@tar -xzf $(NVIM_TEMP_ARCHIVE) -C $(NVIM_TEMP_EXTRACT)
	@mv $(NVIM_TEMP_EXTRACT)/nvim-linux-x86_64 $(NVIM_TARGET_DIR)
	@chmod +x $(NVIM_BINARY)
	@rm -rf $(NVIM_TEMP_ARCHIVE) $(NVIM_TEMP_EXTRACT)
	@echo "✅ Neovim installed at $(NVIM_BINARY)"

install-tmux:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===          Installing Tmux      ==="
	@echo "🔧 =====================================\n"
	@if ! command -v tmux >/dev/null 2>&1; then \
		echo "📦 Installing tmux..."; \
		sudo apt-get update && sudo apt-get install -y tmux; \
	else \
		echo "✅ Tmux is already installed."; \
	fi

	@if [ ! -d "$(TPM_TARGET)" ]; then \
		echo "📦 Installing TPM (Tmux Plugin Manager)..."; \
		git clone $(TPM_URL) $(TPM_TARGET); \
	else \
		echo "✅ TPM is already installed at $(TPM_TARGET)."; \
	fi


install-fzf:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===            Installing fzf     ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR) $(FZF_TARGET_DIR)
	@curl -L $(FZF_URL) -o $(TEMP_DIR)/$(FZF_FILE)
	@rm -rf $(FZF_TEMP_EXTRACT)
	@mkdir -p $(FZF_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(FZF_FILE) -C $(FZF_TEMP_EXTRACT)
	@mv $(FZF_TEMP_EXTRACT)/fzf $(FZF_BINARY)
	@chmod +x $(FZF_BINARY)
	@rm -rf $(TEMP_DIR)/$(FZF_FILE) $(FZF_TEMP_EXTRACT)
	@echo "✅ fzf installed to $(FZF_BINARY)"

install-gitconfig:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===        Setting up Git config  ==="
	@echo "🔧 =====================================\n"
	@if [ -f $(GITCONFIG_FILE) ]; then \
		echo "🔁 Existing .gitconfig found. Replacing with symlink..."; \
		rm -f $(GITCONFIG_FILE); \
	fi
	@ln -snf $(GITCONFIG_SOURCE) $(GITCONFIG_FILE)
	@echo "✅ Linked ~/.gitconfig → $(GITCONFIG_SOURCE)"

install-zsh:
	@echo "\n\n\n\n🐚 ====================================="
	@echo "🐚 ===        Installing Zsh         ==="
	@echo "🐚 =====================================\n"
	@if ! command -v zsh >/dev/null 2>&1; then \
		echo "📦 Installing zsh..."; \
		sudo apt-get update && sudo apt-get install -y zsh; \
	else \
		echo "✅ Zsh is already installed."; \
	fi
	@CURRENT_SHELL=$$(getent passwd "$$(whoami)" | cut -d: -f7); \
	ZSH_PATH=$$(command -v zsh); \
	if [ "$$CURRENT_SHELL" != "$$ZSH_PATH" ]; then \
		echo "🔁 Changing default shell to $$ZSH_PATH..."; \
		chsh -s "$$ZSH_PATH"; \
		echo "🔔 Please log out and back in again to start using zsh as your shell."; \
	else \
		echo "✅ Zsh is already the default shell."; \
	fi

install-fonts:
	@echo "\n\n\n\n🔡 ====================================="
	@echo "🔡 ===    Installing Hack Nerd Font  ==="
	@echo "🔡 =====================================\n"
	@mkdir -p $(FONTS_DIR) $(TEMP_DIR)
	@curl -Lo $(HACK_FONT_ZIP) $(HACK_FONT_URL)
	@unzip -o $(HACK_FONT_ZIP) -d $(FONTS_DIR)
	@rm -f $(HACK_FONT_ZIP)
	@fc-cache -fv > /dev/null
	@echo "✅ Hack Nerd Font installed to $(FONTS_DIR)"

install-flux:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===        Installing Flux CD     ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(FLUX_TARGET_DIR)
	@curl -Lo $(TEMP_DIR)/$(FLUX_FILE) $(FLUX_URL)
	@rm -rf $(FLUX_TEMP_EXTRACT)
	@mkdir -p $(FLUX_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(FLUX_FILE) -C $(FLUX_TEMP_EXTRACT)
	@mv $(FLUX_TEMP_EXTRACT)/flux $(FLUX_BINARY)
	@chmod +x $(FLUX_BINARY)
	@rm -rf $(TEMP_DIR)/$(FLUX_FILE) $(FLUX_TEMP_EXTRACT)
	@echo "✅ Flux installed at $(FLUX_BINARY)"


install-k9s:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===        Installing k9s         ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(K9S_TARGET_DIR)
	@curl -Lo $(TEMP_DIR)/$(K9S_FILE) $(K9S_URL)
	@rm -rf $(K9S_TEMP_EXTRACT)
	@mkdir -p $(K9S_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(K9S_FILE) -C $(K9S_TEMP_EXTRACT)
	@mv $(K9S_TEMP_EXTRACT)/k9s $(K9S_BINARY)
	@chmod +x $(K9S_BINARY)
	@rm -rf $(TEMP_DIR)/$(K9S_FILE) $(K9S_TEMP_EXTRACT)
	@echo "✅ k9s installed at $(K9S_BINARY)"

clean:
	@echo "\n\n\n\n🧹 ====================================="
	@echo "🧹 ===           Cleaning Up        ==="
	@echo "🧹 =====================================\n"
	@echo "🧹 Removing binaries in $(BIN_DIR)"
	@echo "🧹 Removing temporary files in $(TEMP_DIR)"
	@echo "🧹 Removing Neovim config from ~/.config/nvim"
	@rm -rf $(BIN_DIR) $(TEMP_DIR) $(HOME)/.config/nvim
	@echo "✅ Cleanup complete."

link:
	@echo "\n\n\n\n🔗 ====================================="
	@echo "🔗 ===        Linking Configs        ==="
	@echo "🔗 =====================================\n"

	@mkdir -p $(HOME)/.config

	@ln -snf $(KICKSTART_DIR)/nvim $(HOME)/.config/nvim
	@echo "✅ Linked nvim config contents → ~/.config/nvim/"

	@mkdir -p $(HOME)/.config/kitty
	@ln -snf $(KICKSTART_DIR)/kitty/kitty.conf $(HOME)/.config/kitty/kitty.conf
	@echo "✅ Linked kitty config: ~/.config/kitty/kitty.conf → $(KICKSTART_DIR)/kitty/kitty.conf"

	@mkdir -p $(HOME)/.config
	@ln -snf $(TMUX_SOURCE) $(TMUX_FILE)
	@echo "✅ Linked .tmux.conf → $(TMUX_SOURCE)"


	@ln -snf $(ZSHRC_SOURCE) $(ZSHRC_FILE)
	@echo "✅ Linked .zshrc → $(ZSHRC_SOURCE)"

	@ln -snf $(P10K_SOURCE) $(P10K_FILE)
	@echo "✅ Linked .p10k.zsh → $(P10K_SOURCE)"

path:
	@echo "\n\n\n\n📂 ====================================="
	@echo "📂 ===        PATH Setup (dev)      ==="
	@echo "📂 =====================================\n"
	@echo '📂 export PATH="$(NVIM_TARGET_DIR)/bin:$(FZF_TARGET_DIR):$$PATH"'

