#!/bin/bash
#
# Claude Dev Kit - Fallback Installer
# For users without Claude Code CLI
#
# Usage: curl -fsSL https://raw.githubusercontent.com/claude-dev-kit/claude-dev-kit/main/install.sh | bash
#    or: ./install.sh [--bundle minimal|standard|full] [--non-interactive]
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CDK_VERSION="1.0.0"
CDK_REPO="https://github.com/claude-dev-kit/claude-dev-kit"
BACKUP_DIR="$HOME/.claude-dev-kit/backups/$(date +%Y-%m-%d)"

# Flags
BUNDLE=""
NON_INTERACTIVE=false

# ------------------------------------------------------------------------------
# Utility Functions
# ------------------------------------------------------------------------------

print_banner() {
  echo -e "${CYAN}"
  echo "  ╔═══════════════════════════════════════╗"
  echo "  ║        Claude Dev Kit Installer       ║"
  echo "  ║              v${CDK_VERSION}                    ║"
  echo "  ╚═══════════════════════════════════════╝"
  echo -e "${NC}"
}

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
  if $NON_INTERACTIVE; then
    return 0
  fi
  read -r -p "$1 [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY]) return 0 ;;
    *) return 1 ;;
  esac
}

# ------------------------------------------------------------------------------
# Dependency Checks
# ------------------------------------------------------------------------------

check_os() {
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux) OS="linux" ;;
    *) log_error "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
  log_info "Detected OS: $OS"
}

check_command() {
  command -v "$1" >/dev/null 2>&1
}

check_dependencies() {
  log_info "Checking dependencies..."

  local missing=()

  # Required
  if ! check_command git; then
    missing+=("git")
  fi

  if ! check_command curl; then
    missing+=("curl")
  fi

  # Optional but recommended
  if ! check_command brew && [ "$OS" = "macos" ]; then
    log_warn "Homebrew not found. Some components may require manual installation."
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    log_error "Missing required dependencies: ${missing[*]}"
    echo ""
    if [ "$OS" = "macos" ]; then
      echo "Install with Homebrew:"
      echo "  brew install ${missing[*]}"
    else
      echo "Install with your package manager:"
      echo "  apt install ${missing[*]}  # Debian/Ubuntu"
      echo "  dnf install ${missing[*]}  # Fedora"
    fi
    exit 1
  fi

  log_success "All required dependencies found"
}

# ------------------------------------------------------------------------------
# Environment Detection
# ------------------------------------------------------------------------------

detect_environment() {
  log_info "Analyzing environment..."

  GREENFIELD=true

  # Check for existing shell customization
  if [ -d "$HOME/.oh-my-zsh" ] || [ -f "$HOME/.p10k.zsh" ]; then
    log_info "  Found: Custom shell setup"
    GREENFIELD=false
  fi

  # Check for existing git config
  if [ -f "$HOME/.gitconfig" ] && [ "$(wc -l < "$HOME/.gitconfig")" -gt 5 ]; then
    log_info "  Found: Customized git config"
    GREENFIELD=false
  fi

  # Check for VS Code
  if check_command code; then
    VSCODE_EXTENSIONS=$(code --list-extensions 2>/dev/null | wc -l)
    if [ "$VSCODE_EXTENSIONS" -gt 10 ]; then
      log_info "  Found: VS Code with $VSCODE_EXTENSIONS extensions"
      GREENFIELD=false
    fi
  fi

  # Check for existing Claude setup
  if [ -d "$HOME/.claude" ]; then
    log_info "  Found: Existing Claude configuration"
    GREENFIELD=false
  fi

  if $GREENFIELD; then
    log_info "Environment: ${GREEN}Greenfield${NC} (fresh setup)"
    MODE="greenfield"
  else
    log_info "Environment: ${YELLOW}Adaptation${NC} (existing setup detected)"
    MODE="adaptation"
  fi
}

# ------------------------------------------------------------------------------
# Bundle Selection
# ------------------------------------------------------------------------------

select_bundle() {
  if [ -n "$BUNDLE" ]; then
    log_info "Using bundle: $BUNDLE"
    return
  fi

  if $NON_INTERACTIVE; then
    BUNDLE="standard"
    log_info "Non-interactive mode: using standard bundle"
    return
  fi

  echo ""
  echo -e "${CYAN}Select installation bundle:${NC}"
  echo ""
  echo "  1) minimal   - Shell only (zsh, powerlevel10k, completions)"
  echo "  2) standard  - Shell + Editor + Git + Templates (recommended)"
  echo "  3) full      - Everything including Quality and Memory tools"
  echo "  4) custom    - Choose individual components"
  echo ""

  read -r -p "Enter choice [1-4]: " choice

  case "$choice" in
    1) BUNDLE="minimal" ;;
    2) BUNDLE="standard" ;;
    3) BUNDLE="full" ;;
    4) select_custom_components ;;
    *) BUNDLE="standard" ;;
  esac

  log_info "Selected bundle: $BUNDLE"
}

select_custom_components() {
  BUNDLE="custom"
  COMPONENTS=()

  echo ""
  echo -e "${CYAN}Select components to install:${NC}"
  echo ""

  if confirm "  Shell (zsh, powerlevel10k, aliases)?"; then
    COMPONENTS+=("shell")
  fi

  if confirm "  Editor (VS Code/Cursor settings, extensions)?"; then
    COMPONENTS+=("editor")
  fi

  if confirm "  Git (hooks, templates, conventions)?"; then
    COMPONENTS+=("git")
  fi

  if confirm "  Templates (CLAUDE.md, .claude/ directory)?"; then
    COMPONENTS+=("templates")
  fi

  if confirm "  Quality (linting, testing, review)?"; then
    COMPONENTS+=("quality")
  fi

  if confirm "  Memory (context management)?"; then
    COMPONENTS+=("memory")
  fi

  if [ ${#COMPONENTS[@]} -eq 0 ]; then
    log_warn "No components selected. Using minimal bundle."
    BUNDLE="minimal"
  fi
}

get_bundle_components() {
  case "$BUNDLE" in
    minimal)  echo "shell" ;;
    standard) echo "shell editor git templates" ;;
    full)     echo "shell editor git templates quality memory" ;;
    custom)   echo "${COMPONENTS[*]}" ;;
  esac
}

# ------------------------------------------------------------------------------
# Backup
# ------------------------------------------------------------------------------

create_backup() {
  if [ "$MODE" = "adaptation" ]; then
    log_info "Creating backups in $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    # Backup shell configs
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.bak"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc.bak"

    # Backup git configs
    [ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig.bak"
    [ -f "$HOME/.gitmessage" ] && cp "$HOME/.gitmessage" "$BACKUP_DIR/.gitmessage.bak"

    # Backup VS Code settings
    if [ "$OS" = "macos" ]; then
      VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    else
      VSCODE_DIR="$HOME/.config/Code/User"
    fi
    [ -f "$VSCODE_DIR/settings.json" ] && cp "$VSCODE_DIR/settings.json" "$BACKUP_DIR/vscode-settings.json.bak"

    log_success "Backups created"
  fi
}

# ------------------------------------------------------------------------------
# Component Installers
# ------------------------------------------------------------------------------

install_shell() {
  log_info "Installing Shell component..."

  # Install Oh My Zsh if not present
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "  Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    log_info "  Oh My Zsh already installed"
  fi

  # Install Powerlevel10k
  P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    log_info "  Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  else
    log_info "  Updating Powerlevel10k..."
    cd "$P10K_DIR" && git pull --quiet
  fi

  # Install fonts
  log_info "  Installing MesloLGS NF fonts..."
  if [ "$OS" = "macos" ]; then
    FONT_DIR="$HOME/Library/Fonts"
  else
    FONT_DIR="$HOME/.local/share/fonts"
  fi
  mkdir -p "$FONT_DIR"

  for style in Regular Bold Italic "Bold Italic"; do
    FONT_FILE="MesloLGS NF ${style}.ttf"
    FONT_URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${style// /%20}.ttf"
    if [ ! -f "$FONT_DIR/$FONT_FILE" ]; then
      curl -sL -o "$FONT_DIR/$FONT_FILE" "$FONT_URL"
    fi
  done

  [ "$OS" = "linux" ] && fc-cache -f 2>/dev/null

  # Install plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log_info "  Installing zsh-autosuggestions..."
    git clone --quiet https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log_info "  Installing zsh-syntax-highlighting..."
    git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi

  # Update .zshrc
  if ! grep -q "powerlevel10k" "$HOME/.zshrc" 2>/dev/null; then
    log_info "  Configuring .zshrc..."
    sed -i.bak 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
  fi

  # Add plugins
  if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc" 2>/dev/null; then
    sed -i.bak 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
  fi

  # Add Claude aliases
  if ! grep -q "Claude Dev Kit" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Claude Dev Kit aliases
alias cc='claude'
alias ccp='claude -p'
alias ccc='claude --continue'
alias ccr='claude --resume'
EOF
  fi

  log_success "Shell component installed"
}

install_editor() {
  log_info "Installing Editor component..."

  # Detect editor
  EDITOR_CMD=""
  if check_command cursor; then
    EDITOR_CMD="cursor"
    log_info "  Detected: Cursor"
  elif check_command code; then
    EDITOR_CMD="code"
    log_info "  Detected: VS Code"
  else
    log_warn "  No supported editor found (VS Code or Cursor)"
    return
  fi

  # Install extensions
  log_info "  Installing extensions..."
  $EDITOR_CMD --install-extension eamodio.gitlens 2>/dev/null || true
  $EDITOR_CMD --install-extension usernamehw.errorlens 2>/dev/null || true
  $EDITOR_CMD --install-extension esbenp.prettier-vscode 2>/dev/null || true
  $EDITOR_CMD --install-extension dbaeumer.vscode-eslint 2>/dev/null || true
  $EDITOR_CMD --install-extension streetsidesoftware.code-spell-checker 2>/dev/null || true

  # Configure settings
  if [ "$OS" = "macos" ]; then
    if [ "$EDITOR_CMD" = "cursor" ]; then
      SETTINGS_DIR="$HOME/Library/Application Support/Cursor/User"
    else
      SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
    fi
  else
    if [ "$EDITOR_CMD" = "cursor" ]; then
      SETTINGS_DIR="$HOME/.config/Cursor/User"
    else
      SETTINGS_DIR="$HOME/.config/Code/User"
    fi
  fi

  mkdir -p "$SETTINGS_DIR"

  # Only add settings if not already configured
  if [ ! -f "$SETTINGS_DIR/settings.json" ]; then
    log_info "  Creating settings.json..."
    cat > "$SETTINGS_DIR/settings.json" << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.minimap.enabled": false,
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "files.autoSave": "onFocusChange",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "errorLens.enabledDiagnosticLevels": ["error", "warning"],
  "gitlens.codeLens.enabled": false,
  "gitlens.currentLine.enabled": true
}
EOF
  else
    log_info "  Settings.json exists, skipping (use skill for merge)"
  fi

  log_success "Editor component installed"
}

install_git() {
  log_info "Installing Git component..."

  # Commit template
  log_info "  Creating commit template..."
  cat > "$HOME/.gitmessage" << 'EOF'
# <type>(<scope>): <subject>
#
# Types: feat, fix, docs, style, refactor, test, chore
#
# Co-Authored-By: Claude <noreply@anthropic.com>
EOF
  git config --global commit.template "$HOME/.gitmessage"

  # Global gitignore
  log_info "  Creating global gitignore..."
  cat > "$HOME/.gitignore_global" << 'EOF'
.DS_Store
*.swp
*.swo
.idea/
.vscode/
.claude-context/
*.claude-session
.env.local
.env.*.local
EOF
  git config --global core.excludesfile "$HOME/.gitignore_global"

  # Hooks
  log_info "  Installing git hooks..."
  HOOKS_DIR="$HOME/.config/git/hooks"
  mkdir -p "$HOOKS_DIR"

  cat > "$HOOKS_DIR/commit-msg" << 'EOF'
#!/bin/bash
commit_regex='^(feat|fix|docs|style|refactor|test|chore|build|ci)(\(.+\))?: .{1,50}'
if ! grep -qE "$commit_regex" "$1"; then
  echo "Error: Commit message doesn't follow conventional format."
  echo "Expected: <type>(<scope>): <subject>"
  exit 1
fi
EOF
  chmod +x "$HOOKS_DIR/commit-msg"
  git config --global core.hooksPath "$HOOKS_DIR"

  # Aliases
  log_info "  Adding git aliases..."
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.wip 'commit -am "wip: work in progress"'
  git config --global alias.undo 'reset --soft HEAD~1'

  log_success "Git component installed"
}

install_templates() {
  log_info "Installing Templates component..."

  # Create .claude directory structure
  log_info "  Creating .claude/ template..."
  mkdir -p "$HOME/.claude-dev-kit/templates/.claude/commands"

  cat > "$HOME/.claude-dev-kit/templates/.claude/commands/test.md" << 'EOF'
Run all tests and report results. If tests fail, analyze the failure and suggest fixes.
EOF

  cat > "$HOME/.claude-dev-kit/templates/.claude/commands/review.md" << 'EOF'
Review recent changes for code quality, bugs, performance, and security.
Provide specific, actionable feedback.
EOF

  # Create CLAUDE.md template
  cat > "$HOME/.claude-dev-kit/templates/CLAUDE.md" << 'EOF'
# Project Context

## Overview
[Brief description]

## Tech Stack
- [List technologies]

## Directory Structure
- [Key directories]

## Commands
- [Common commands]

## Conventions
- [Naming and style]

## Important Notes
- [Critical info]
EOF

  log_info "  Templates saved to ~/.claude-dev-kit/templates/"
  log_info "  Copy to your project: cp -r ~/.claude-dev-kit/templates/.claude ."

  log_success "Templates component installed"
}

install_quality() {
  log_info "Installing Quality component..."
  log_warn "  Quality component requires per-project setup."
  log_info "  Use Claude Code with 'setup-cdk-quality' skill for full installation."
  log_success "Quality component noted (manual setup required)"
}

install_memory() {
  log_info "Installing Memory component..."
  log_warn "  Memory component requires Claude Code."
  log_info "  Use Claude Code with 'setup-cdk-memory' skill for full installation."
  log_success "Memory component noted (manual setup required)"
}

# ------------------------------------------------------------------------------
# Main Installation
# ------------------------------------------------------------------------------

install_components() {
  COMPONENTS_TO_INSTALL=$(get_bundle_components)

  log_info "Installing components: $COMPONENTS_TO_INSTALL"
  echo ""

  for component in $COMPONENTS_TO_INSTALL; do
    case "$component" in
      shell)     install_shell ;;
      editor)    install_editor ;;
      git)       install_git ;;
      templates) install_templates ;;
      quality)   install_quality ;;
      memory)    install_memory ;;
    esac
    echo ""
  done
}

print_summary() {
  echo ""
  echo -e "${GREEN}════════════════════════════════════════${NC}"
  echo -e "${GREEN}  Installation Complete!${NC}"
  echo -e "${GREEN}════════════════════════════════════════${NC}"
  echo ""
  echo "Installed components:"
  for component in $(get_bundle_components); do
    echo -e "  ${GREEN}✓${NC} $component"
  done
  echo ""

  if [ "$MODE" = "adaptation" ]; then
    echo "Backups saved to: $BACKUP_DIR"
    echo ""
  fi

  echo "Next steps:"
  echo "  1. Restart your terminal (or run: source ~/.zshrc)"
  echo "  2. Run 'p10k configure' to set up your prompt"
  echo "  3. Set terminal font to 'MesloLGS NF'"
  echo ""
  echo "For the best experience, install Claude Code:"
  echo "  npm install -g @anthropic-ai/claude-code"
  echo ""
  echo "Then run: claude 'setup-claude-dev-kit'"
  echo ""
}

# ------------------------------------------------------------------------------
# Argument Parsing
# ------------------------------------------------------------------------------

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --bundle)
        BUNDLE="$2"
        shift 2
        ;;
      --non-interactive)
        NON_INTERACTIVE=true
        shift
        ;;
      --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --bundle <name>     Install specific bundle (minimal, standard, full)"
        echo "  --non-interactive   Skip prompts, use defaults"
        echo "  --help              Show this help"
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        exit 1
        ;;
    esac
  done
}

# ------------------------------------------------------------------------------
# Entry Point
# ------------------------------------------------------------------------------

main() {
  parse_args "$@"

  print_banner

  check_os
  check_dependencies
  detect_environment

  echo ""
  if [ "$MODE" = "adaptation" ] && ! $NON_INTERACTIVE; then
    if ! confirm "Existing setup detected. Continue with adaptation mode?"; then
      log_info "Installation cancelled."
      exit 0
    fi
  fi

  select_bundle
  create_backup

  echo ""
  install_components

  print_summary
}

main "$@"
