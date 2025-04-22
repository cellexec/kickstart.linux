# Base Directories
DOTFILES_DIR := $(HOME)/projects/dotfiles
BIN_DIR := $(DOTFILES_DIR)/bin
TEMP_DIR := $(DOTFILES_DIR)/temp

# Neovim
NVIM_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
NVIM_TEMP_EXTRACT := $(TEMP_DIR)/nvim
NVIM_TEMP_ARCHIVE := $(TEMP_DIR)/nvim.tar.gz
NVIM_TARGET_DIR := $(BIN_DIR)/nvim
NVIM_BINARY := $(NVIM_TARGET_DIR)/bin/nvim

# FZF
FZF_VERSION := 0.61.2
FZF_TAG := v$(FZF_VERSION)
FZF_FILE := fzf-$(FZF_VERSION)-linux_amd64.tar.gz
FZF_URL := https://github.com/junegunn/fzf/releases/download/$(FZF_TAG)/$(FZF_FILE)
FZF_TEMP_EXTRACT := $(TEMP_DIR)/fzf
FZF_TARGET_DIR := $(BIN_DIR)/fzf
FZF_BINARY := $(FZF_TARGET_DIR)/fzf

.PHONY: all install install-nvim install-fzf clean link path

all: install link

install: install-nvim install-fzf

install-nvim:
	@echo "\n🔧 === Installing Neovim ==="
	@echo "📥 Downloading and installing Neovim..."
	@mkdir -p $(TEMP_DIR) $(BIN_DIR)
	@curl -L $(NVIM_URL) -o $(NVIM_TEMP_ARCHIVE)
	@rm -rf $(NVIM_TEMP_EXTRACT) $(NVIM_TARGET_DIR)
	@mkdir -p $(NVIM_TEMP_EXTRACT)
	@tar -xzf $(NVIM_TEMP_ARCHIVE) -C $(NVIM_TEMP_EXTRACT)
	@mv $(NVIM_TEMP_EXTRACT)/nvim-linux-x86_64 $(NVIM_TARGET_DIR)
	@chmod +x $(NVIM_BINARY)
	@rm -rf $(NVIM_TEMP_ARCHIVE) $(NVIM_TEMP_EXTRACT)
	@echo "✅ Neovim installed at $(NVIM_BINARY)"

install-fzf:
	@echo "\n🔧 === Installing fzf ==="
	@echo "📥 Downloading and installing fzf..."
	@mkdir -p $(TEMP_DIR) $(BIN_DIR) $(FZF_TARGET_DIR)
	@curl -L $(FZF_URL) -o $(TEMP_DIR)/$(FZF_FILE)
	@rm -rf $(FZF_TEMP_EXTRACT)
	@mkdir -p $(FZF_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/$(FZF_FILE) -C $(FZF_TEMP_EXTRACT)
	@mv $(FZF_TEMP_EXTRACT)/fzf $(FZF_BINARY)
	@chmod +x $(FZF_BINARY)
	@rm -rf $(TEMP_DIR)/$(FZF_FILE) $(FZF_TEMP_EXTRACT)
	@echo "✅ fzf installed to $(FZF_BINARY)"

clean:
	@echo "\n🧹 === Cleaning up ==="
	@echo "🧹 Cleaning up all installed tools and temp files..."
	@rm -rf $(BIN_DIR)
	@rm -rf $(TEMP_DIR)
	@rm -rf $(HOME)/.config/nvim

link:
	@echo "\n🔗 === Linking Configs ==="
	@echo "🔗 Symlinking config files..."
	@mkdir -p $(HOME)/.config
	@ln -snf $(DOTFILES_DIR)/nvim $(HOME)/.config/nvim
	@echo "✅ Linked nvim config: ~/.config/nvim → $(DOTFILES_DIR)/nvim"

path:
	@echo "\n📂 === PATH Setup (Testing Only) ==="
	@echo "📂 Export this in your shell to test the tools:"
	@echo 'export PATH="$(NVIM_TARGET_DIR)/bin:$(FZF_TARGET_DIR):$$PATH"'
	@echo

