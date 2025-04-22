# Variables
DOTFILES_DIR := $(HOME)/projects/dotfiles
BIN_DIR := $(DOTFILES_DIR)/bin
TEMP_DIR := $(DOTFILES_DIR)/temp
NVIM_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
NVIM_TEMP_EXTRACT := $(TEMP_DIR)/nvim
NVIM_TARGET_DIR := $(BIN_DIR)/nvim
NVIM_BINARY := $(NVIM_TARGET_DIR)/nvim

.PHONY: all install clean

all: install

install:
	@echo "📥 Downloading and installing Neovim..."
	@mkdir -p $(TEMP_DIR) $(BIN_DIR) $(NVIM_TARGET_DIR)
	@curl -L $(NVIM_URL) -o $(TEMP_DIR)/nvim.tar.gz
	@rm -rf $(NVIM_TEMP_EXTRACT)
	@mkdir -p $(NVIM_TEMP_EXTRACT)
	@tar -xzf $(TEMP_DIR)/nvim.tar.gz -C $(NVIM_TEMP_EXTRACT)
	@mv $(NVIM_TEMP_EXTRACT)/nvim-linux-x86_64/bin/nvim $(NVIM_BINARY)
	@chmod +x $(NVIM_BINARY)
	@rm -rf $(TEMP_DIR)/nvim.tar.gz $(NVIM_TEMP_EXTRACT)
	@echo "✅ Neovim installed to $(NVIM_BINARY)"

clean:
	@echo "🧹 Cleaning up Neovim install..."
	@rm -rf $(NVIM_TARGET_DIR)

