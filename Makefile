# ============================================
# ===           💻 Kickstart.Linux          ===
# ============================================

# 📁 Base Directories
KICKSTART_DIR := $(HOME)/projects/kickstart.linux
BIN_DIR := $(KICKSTART_DIR)/bin
TEMP_DIR := $(KICKSTART_DIR)/temp

# 📦 Architecture Detection
ARCH := $(shell uname -m)
ifeq ($(ARCH),x86_64)
    PLATFORM_ARCH := amd64
    BINARY_ARCH := x86_64
else ifeq ($(ARCH),aarch64)
    PLATFORM_ARCH := arm64
    BINARY_ARCH := arm64
else
    $(error Unsupported architecture: $(ARCH))
endif

# 📦 GitLab CLI (glab)
GLAB_VERSION := 1.62.0
GLAB_FILE := glab_$(GLAB_VERSION)_linux_$(PLATFORM_ARCH).tar.gz
GLAB_URL := https://gitlab.com/gitlab-org/cli/-/releases/v$(GLAB_VERSION)/downloads/$(GLAB_FILE)
GLAB_TEMP_EXTRACT := $(TEMP_DIR)/glab
GLAB_TARGET_DIR := $(BIN_DIR)
GLAB_BINARY := $(GLAB_TARGET_DIR)/glab

# 📦 Neovim
NVIM_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$(BINARY_ARCH).tar.gz
NVIM_TEMP_EXTRACT := $(TEMP_DIR)/nvim
NVIM_TEMP_ARCHIVE := $(TEMP_DIR)/nvim.tar.gz
NVIM_TARGET_DIR := $(BIN_DIR)/nvim
NVIM_BINARY := $(NVIM_TARGET_DIR)/bin/nvim

# 📦 Tmux
TPM_URL := https://github.com/tmux-plugins/tpm
TPM_TARGET := $(HOME)/.tmux/plugins/tpm
TMUX_CONFIG_SRC := $(KICKSTART_DIR)/tmux/.tmux.conf
TMUX_CONFIG_DEST := $(HOME)/.tmux.conf
TMUX_SCRIPT_SRC := $(KICKSTART_DIR)/tmux/new-k8s-window.sh
TMUX_SCRIPT_DEST := $(HOME)/.tmux/new-k8s-window.sh

# 📦 fzf
FZF_VERSION := 0.61.3
FZF_FILE := fzf-$(FZF_VERSION)-linux_$(PLATFORM_ARCH).tar.gz
FZF_URL := https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/$(FZF_FILE)
FZF_TEMP_EXTRACT := $(TEMP_DIR)/fzf
FZF_TARGET_DIR := $(BIN_DIR)
FZF_BINARY := $(FZF_TARGET_DIR)/fzf

# 📦 k9s
K9S_VERSION := 0.50.6
K9S_FILE := k9s_Linux_$(PLATFORM_ARCH).tar.gz
K9S_URL := https://github.com/derailed/k9s/releases/download/v$(K9S_VERSION)/$(K9S_FILE)
K9S_TEMP_EXTRACT := $(TEMP_DIR)/k9s
K9S_TARGET_DIR := $(BIN_DIR)
K9S_BINARY := $(K9S_TARGET_DIR)/k9s
K9S_CONFIG_SRC := $(KICKSTART_DIR)/k9s/config.yaml
K9S_CONFIG_DEST := $(HOME)/.config/k9s/config.yaml

# ⚙️ Git
GITCONFIG_FILE := $(HOME)/.gitconfig
GITCONFIG_SOURCE := $(KICKSTART_DIR)/git/.gitconfig

# 🐚 Zsh
ZSHRC_FILE := $(HOME)/.zshrc
ZSHRC_SOURCE := $(KICKSTART_DIR)/zsh/.zshrc
P10K_FILE := $(HOME)/.p10k.zsh
P10K_SOURCE := $(KICKSTART_DIR)/zsh/.p10k.zsh

# 📦 Flux CLI
FLUX_VERSION := 2.5.1
FLUX_FILE := flux_$(FLUX_VERSION)_linux_$(PLATFORM_ARCH).tar.gz
FLUX_URL := https://github.com/fluxcd/flux2/releases/download/v$(FLUX_VERSION)/$(FLUX_FILE)
FLUX_TEMP_EXTRACT := $(TEMP_DIR)/flux
FLUX_TARGET_DIR := $(BIN_DIR)
FLUX_BINARY := $(FLUX_TARGET_DIR)/flux

# 📦 Kind
KIND_VERSION := 0.28.0
KIND_FILE := kind-linux-$(PLATFORM_ARCH)
KIND_URL := https://kind.sigs.k8s.io/dl/v$(KIND_VERSION)/$(KIND_FILE)
KIND_TARGET_DIR := $(BIN_DIR)
KIND_BINARY := $(KIND_TARGET_DIR)/kind

# 🔡 Fonts
FONTS_DIR := $(HOME)/.local/share/fonts
HACK_FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
HACK_FONT_ZIP := $(TEMP_DIR)/Hack.zip

# 🛠️ Targets
.PHONY: all install install-nvim install-fzf install-gitconfig install-zsh install-fonts install-tmux install-flux install-k9s install-kind clean link path

all: install link

install: install-build-essentials install-nvim install-fzf install-tmux install-gitconfig install-zsh install-fonts install-flux install-k9s install-kind install-glab

install-build-essentials:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===        Installing Prerequisites      ==="
	@echo "🔧 =====================================\n"

	@if ! command -v node >/dev/null 2>&1; then \
		echo "📦 Installing nodejs..."; \
		sudo apt-get update && sudo apt-get install -y nodejs npm; \
	else \
		echo "✅ nodejs is already installed."; \
	fi

	@if ! command -v gcc >/dev/null 2>&1; then \
		echo "📦 Installing build-essential..."; \
		sudo apt-get update && sudo apt-get install -y build-essential; \
	else \
		echo "✅ build-essential is already installed."; \
	fi

	@if ! command -v rg >/dev/null 2>&1; then \
		echo "📦 Installing ripgrep..."; \
		sudo apt-get update && sudo apt-get install -y ripgrep; \
	else \
		echo "✅ ripgrep is already installed."; \
	fi

	@if ! command -v curl >/dev/null 2>&1; then \
		echo "📦 Installing curl..."; \
		sudo apt-get update && sudo apt-get install -y curl; \
	else \
		echo "✅ curl is already installed."; \
	fi

	@if ! command -v tar >/dev/null 2>&1; then \
		echo "📦 Installing tar..."; \
		sudo apt-get update && sudo apt-get install -y tar; \
	else \
		echo "✅ tar is already installed."; \
	fi
	@echo "✅ All essential prerequisites checked/installed."

install-nvim:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===           Installing Neovim    ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
	@curl -L $(NVIM_URL) -o $(NVIM_TEMP_ARCHIVE)
	@rm -rf $(NVIM_TEMP_EXTRACT) $(NVIM_TARGET_DIR)
	@mkdir -p $(NVIM_TEMP_EXTRACT)
	@tar -xzf $(NVIM_TEMP_ARCHIVE) -C $(NVIM_TEMP_EXTRACT)
	@mv $(NVIM_TEMP_EXTRACT)/nvim-$(BINARY_ARCH) $(NVIM_TARGET_DIR) || mv $(NVIM_TEMP_EXTRACT)/nvim-linux-$(BINARY_ARCH) $(NVIM_TARGET_DIR)
	@chmod +x $(NVIM_BINARY)
	@rm -rf $(NVIM_TEMP_ARCHIVE) $(NVIM_TEMP_EXTRACT)
	@echo "✅ Neovim installed at $(NVIM_BINARY)"

install-tmux:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===           Installing Tmux      ==="
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
	@echo "🔧 ===             Installing fzf     ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
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
	@echo "🔧 ===         Setting up Git config  ==="
	@echo "🔧 =====================================\n"
	@if [ -f $(GITCONFIG_FILE) ]; then \
		echo "🔁 Existing .gitconfig found. Replacing with symlink..."; \
		rm -f $(GITCONFIG_FILE); \
	fi
	@ln -snf $(GITCONFIG_SOURCE) $(GITCONFIG_FILE)
	@echo "✅ Linked ~/.gitconfig → $(GITCONFIG_SOURCE)"

install-zsh:
	@echo "\n\n\n\n🐚 ====================================="
	@echo "🐚 ===           Installing Zsh       ==="
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
		echo "🔔 Please log out and back in again to start using zsh."; \
	else \
		echo "✅ Zsh is already the default shell."; \
	fi

install-fonts:
	@echo "\n\n\n\n🔡 ====================================="
	@echo "🔡 ===   Installing Hack Nerd Font    ==="
	@echo "🔡 =====================================\n"
	@if ! command -v unzip >/dev/null 2>&1; then \
		echo "📦 Installing unzip..."; \
		sudo apt-get update && sudo apt-get install -y unzip; \
	else \
		echo "✅ unzip is already installed."; \
	fi
	@if ! command -v fc-cache >/dev/null 2>&1; then \
		echo "📦 Installing fontconfig (for fc-cache)..."; \
		sudo apt-get update && sudo apt-get install -y fontconfig; \
	else \
		echo "✅ fontconfig (fc-cache) is already installed."; \
	fi
	@mkdir -p $(FONTS_DIR) $(TEMP_DIR)
	@curl -Lo $(HACK_FONT_ZIP) $(HACK_FONT_URL)
	@unzip -o $(HACK_FONT_ZIP) -d $(FONTS_DIR)
	@rm -f $(HACK_FONT_ZIP)
	@fc-cache -fv > /dev/null
	@echo "✅ Hack Nerd Font installed to $(FONTS_DIR)"

install-flux:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===           Installing Flux CD   ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
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
	@echo "🔧 ===           Installing k9s       ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
	@curl -Lo $(TEMP_DIR)/$(K9S_FILE) $(K9S_URL)
	@rm -rf $(K9S_TEMP_EXTRACT)
	@mkdir -p $(K9S_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(K9S_FILE) -C $(K9S_TEMP_EXTRACT)
	@mv $(K9S_TEMP_EXTRACT)/k9s $(K9S_BINARY)
	@chmod +x $(K9S_BINARY)
	@rm -rf $(TEMP_DIR)/$(K9S_FILE) $(K9S_TEMP_EXTRACT)
	@echo "✅ k9s installed at $(K9S_BINARY)"

install-kind:
	@echo "\n\n\n\n🐳 ====================================="
	@echo "🐳 ===           Installing Kind      ==="
	@echo "🐳 =====================================\n"
	@mkdir -p $(KIND_TARGET_DIR)
	@curl -Lo $(KIND_BINARY) $(KIND_URL)
	@chmod +x $(KIND_BINARY)
	@echo "✅ Kind installed at $(KIND_BINARY)"

install-glab:
	@echo "\n\n\n\n🔧 ====================================="
	@echo "🔧 ===           Installing glab       ==="
	@echo "🔧 =====================================\n"
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
	@curl -Lo $(TEMP_DIR)/$(GLAB_FILE) $(GLAB_URL)
	@rm -rf $(GLAB_TEMP_EXTRACT)
	@mkdir -p $(GLAB_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(GLAB_FILE) -C $(GLAB_TEMP_EXTRACT)
	@mv $(GLAB_TEMP_EXTRACT)/bin/glab $(GLAB_BINARY)
	@chmod +x $(GLAB_BINARY)
	@rm -rf $(TEMP_DIR)/$(GLAB_FILE) $(GLAB_TEMP_EXTRACT)
	@echo "✅ glab installed at $(GLAB_BINARY)"

clean:
	@echo "\n\n\n\n🧹 ====================================="
	@echo "🧹 ===             Cleaning Up        ==="
	@echo "🧹 =====================================\n"
	@echo "🧹 Removing binaries in $(BIN_DIR)"
	@echo "🧹 Removing temporary files in $(TEMP_DIR)"
	@echo "🧹 Removing Neovim config from ~/.config/nvim"
	@rm -rf $(BIN_DIR) $(TEMP_DIR) $(HOME)/.config/nvim
	@echo "✅ Cleanup complete."

link:
	@echo "\n\n\n\n🔗 ====================================="
	@echo "🔗 ===           Linking Configs      ==="
	@echo "🔗 =====================================\n"
	@mkdir -p $(HOME)/.config/kitty
	@ln -snf $(KICKSTART_DIR)/nvim $(HOME)/.config/nvim
	@ln -snf $(KICKSTART_DIR)/kitty/kitty.conf $(HOME)/.config/kitty/kitty.conf
	@ln -snf $(TMUX_CONFIG_SRC) $(TMUX_CONFIG_DEST)
	@ln -snf $(TMUX_SCRIPT_SRC) $(TMUX_SCRIPT_DEST)
	@ln -snf $(ZSHRC_SOURCE) $(ZSHRC_FILE)
	@ln -snf $(P10K_SOURCE) $(P10K_FILE)
	@echo "✅ Configs linked."

path:
	@echo "\n\n\n\n📂 ====================================="
	@echo "📂 ===           PATH Setup (dev)     ==="
	@echo "📂 =====================================\n"
	@echo '📂 export PATH="$(NVIM_TARGET_DIR)/bin:$(BIN_DIR):$$PATH"'

