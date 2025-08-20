# 🪝 zsh-hookie-projects

Language-agnostic project detection plugin for Zsh with customizable `on_project` and
`off_project` hooks.

## Features

- **🔍 Smart Detection**: Automatically detects project directories by common markers
  (`.git`, `pyproject.toml`, `package.json`, etc.)
- **⚡ Performance**: Efficient implementation with minimal overhead (~1-5ms per
  directory change)
- **🎯 Language Agnostic**: Works with any project type - Python, Node.js, Rust, Go,
  Java, PHP, Ruby, etc.
- **🪝 Customizable Hooks**: Define custom behavior when entering/leaving projects
- **📁 Project Root Detection**: Walks up directory tree to find project boundaries
- **🚫 Path Filtering**: Blacklist/whitelist support to avoid unwanted triggers
- **🎨 PowerLevel10k Integration**: Built-in `hookie_dir` segment with intelligent path
  shortening
- **📂 Smart Directory Display**: Project-aware path shortening with color coding
- **⚡ Smart `cd` Command**: Empty `cd` goes to project root instead of home
- **🔇 Message Control**: Configurable notifications for project enter/leave events
- **🌍 Comprehensive Coverage**: Supports 100+ project markers across all major
  languages and tools

## Installation

### Using a Plugin Manager

**Oh My Zsh:**

```bash
git clone https://github.com/yourusername/zsh-hookie-projects ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-hookie-projects
# Add 'zsh-hookie-projects' to plugins array in ~/.zshrc
```

**Zinit:**

```bash
zinit load "yourusername/zsh-hookie-projects"
```

**Manual:**

```bash
git clone https://github.com/yourusername/zsh-hookie-projects ~/.zsh/zsh-hookie-projects
echo "source ~/.zsh/zsh-hookie-projects/zsh-hookie-projects.plugin.zsh" >> ~/.zshrc
```

## Usage

The plugin works automatically once installed. Navigate between directories and watch
the hooks trigger:

```bash
❯ cd ~/projects/zsh-hookie-projects
🚀 Entered project: zsh-hookie-projects (.git, README.md)

❯ cd functions
~/p/zsh-hookie-projects/functions  main ⇡ 1 !3 ⚪2

❯ cd
📁 Going to project root: zsh-hookie-projects
~/p/zsh-hookie-projects  main ⇡ 1 !3 ⚪2

❯ cd ~
👋 Left project: zsh-hookie-projects
~
```

## Environment Variables

The plugin automatically sets these environment variables when entering projects:

- **`HOOKIE_CURRENT_PROJECT`** - Project name (e.g., `my-project`)
- **`HOOKIE_PROJECT_ROOT`** - Full path to project root
- **`HOOKIE_PROJECT_MARKERS_STRING`** - Comma-separated detected markers

```bash
❯ echo $HOOKIE_CURRENT_PROJECT
zsh-hookie-projects

❯ echo $HOOKIE_PROJECT_ROOT
/home/user/projects/zsh-hookie-projects

❯ echo $HOOKIE_PROJECT_MARKERS_STRING
.git, README.md, zsh-hookie-projects.plugin.zsh
```

## PowerLevel10k Integration

### Enhanced Directory Segment

Replace the default `dir` segment with `hookie_dir` for project-aware path display:

```bash
# In your ~/.p10k.zsh, replace 'dir' with 'hookie_dir'
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # ... other elements ...
    hookie_dir      # Use instead of 'dir'
    vcs
    # ... other elements ...
)
```

**Features:**

- **Intelligent Path Shortening**: `~/projects/my-app` → `~/p/my-app`
- **Color-Coded Paths**: Project root in blue, subdirectories in cyan
- **Copy-Pasteable**: Paths work when copied to clipboard
- **Fallback Support**: Standard directory display when not in projects

### Project Name Segment

Add a simple project indicator segment:

```bash
# Add to your prompt elements
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(hookie_project)

# Simple project segment
function prompt_hookie_project() {
    [[ -n "$HOOKIE_CURRENT_PROJECT" ]] && p10k segment -f 6 -t "$HOOKIE_CURRENT_PROJECT"
}
```

### With Dynamic Icons

```bash
function prompt_hookie_project() {
    if [[ -n "$HOOKIE_CURRENT_PROJECT" ]]; then
        local icon="●"
        case "$HOOKIE_PROJECT_MARKERS_STRING" in
            *"pyproject.toml"*) icon="🐍" ;;  # Python
            *"package.json"*)   icon="📦" ;;  # Node.js
            *"Cargo.toml"*)     icon="🦀" ;;  # Rust
            *"go.mod"*)         icon="🐹" ;;  # Go
            *".git"*)           icon="📁" ;;  # Git
        esac
        p10k segment -f 6 -i "$icon" -t "$HOOKIE_CURRENT_PROJECT"
    fi
}
```

### Configure Colors

Add to the **bottom** of your `~/.p10k.zsh`:

```bash
##########################[ hookie_dir: current project + directory ]##########################
# Hookie-dir segment colors (customize as needed)
typeset -g HOOKIE_DIR_PROJECT_COLOR=4      # Blue for project paths
typeset -g HOOKIE_DIR_SUBDIR_COLOR=6       # Cyan for subdirectories
typeset -g HOOKIE_DIR_DEFAULT_COLOR=4      # Blue for non-project directories
```

## Smart `cd` Command

The plugin overrides the `cd` command to provide project-aware navigation:

```bash
❯ cd ~/projects/my-app
🚀 Entered project: my-app

❯ cd src/components
~/p/my-app/src/components

❯ cd              # Goes to project root instead of HOME!
📁 Going to project root: my-app
~/p/my-app

❯ cd ~            # Explicit ~ still works
👋 Left project: my-app
~
```

### Disable Smart `cd`

```bash
# Disable smart cd behavior
export HOOKIE_DISABLE_SMART_CD=1
```

## Message Control

Configure which messages are displayed:

```bash
# Message control flags (set to 0 to disable, 1 to enable)
export HOOKIE_SHOW_ENTERING=1          # Show "🚀 Entered project"
export HOOKIE_SHOW_LEAVING=1           # Show "👋 Left project"
export HOOKIE_SHOW_CD_PROJECT_ROOT=1   # Show "📁 Going to project root"
```

### Silent Mode

```bash
# Completely silent operation
export HOOKIE_SHOW_ENTERING=0
export HOOKIE_SHOW_LEAVING=0
export HOOKIE_SHOW_CD_PROJECT_ROOT=0
```

### Quick Toggle Functions

```bash
# Add these convenience functions to ~/.zshrc
hookie_messages_on() {
    export HOOKIE_SHOW_ENTERING=1
    export HOOKIE_SHOW_LEAVING=1
    export HOOKIE_SHOW_CD_PROJECT_ROOT=1
    echo "🔔 Hookie messages enabled"
}

hookie_messages_off() {
    export HOOKIE_SHOW_ENTERING=0
    export HOOKIE_SHOW_LEAVING=0
    export HOOKIE_SHOW_CD_PROJECT_ROOT=0
    echo "🔇 Hookie messages disabled"
}
```

## Customization

### Custom Project Markers

Add your own project markers in `~/.zshrc`:

```bash
# Add custom markers
HOOKIE_PROJECT_MARKERS+=(
    'deno.json'        # Deno
    'requirements.txt' # Python legacy
    'yarn.lock'        # Yarn
    'flake.nix'        # Nix
    '.project-root'    # Custom marker
)
```

### Path Filtering

**Blacklist Mode (default)** - Block specific directories:

```bash
# Add to ~/.zshrc to customize blacklist
HOOKIE_BLACKLIST_PATHS+=(
    "$HOME/Downloads"          # Downloads folder
    "$HOME/Desktop"            # Desktop
    "$HOME/.Trash"             # Trash
    "/mnt"                     # Mount points
    "$HOME/node_modules"       # npm modules
)
```

**Whitelist Mode** - Only allow specific directories:

```bash
# Enable whitelist mode by adding allowed paths
HOOKIE_WHITELIST_PATHS=(
    "$HOME/projects"           # Only allow ~/projects
    "$HOME/work"               # And ~/work
    "$HOME/dev"                # And ~/dev
    "/workspace"               # And /workspace
)
```

### Custom Hooks

Override the default hook functions to add your own behavior:

```bash
# Custom on_project hook
on_project_hook() {
    local project_root="$1"
    shift
    local markers=("$@")

    echo "🎯 Working on: ${project_root:t}"

    # Auto-activate Python venv
    if (( ${markers[(Ie)pyproject.toml]} )); then
        [[ -d "$project_root/.venv" ]] && source "$project_root/.venv/bin/activate"
    fi

    # Load project environment
    [[ -f "$project_root/.env" ]] && source "$project_root/.env"

    # Set custom environment variables
    export PROJECT_NAME="${project_root:t}"
    export PROJECT_ROOT="$project_root"
}

# Custom off_project hook
off_project_hook() {
    local project_root="$1"

    echo "✨ Goodbye ${project_root:t}"

    # Cleanup
    [[ -n "$VIRTUAL_ENV" ]] && deactivate 2>/dev/null
    unset PROJECT_NAME PROJECT_ROOT
}
```

#### Auto-Activate Python Virtual Environment

Automatically activate Python virtual environments when entering Python projects:

```bash
# Advanced Python project hook with auto-activation
on_project_hook() {
    local project_root="$1"
    shift
    local markers=("$@")

    # Set standard environment variables
    export HOOKIE_CURRENT_PROJECT="${project_root:t}"
    export HOOKIE_PROJECT_ROOT="$project_root"
    typeset -g HOOKIE_PROJECT_MARKERS_STRING="${(j:, :)markers}"
    export HOOKIE_PROJECT_MARKERS_STRING

    # Show entry message (if enabled)
    if [[ "$HOOKIE_SHOW_ENTERING" != "0" ]]; then
        echo "🚀 Entered project: ${project_root:t} (${(j:, :)markers})"
    fi

    # Auto-activate Python virtual environment
    local python_markers=("pyproject.toml" "requirements.txt" "setup.py" ".venv" "venv" "env" "Pipfile")
    local has_python_marker=0

    for marker in "${python_markers[@]}"; do
        if (( ${markers[(Ie)$marker]} )); then
            has_python_marker=1
            break
        fi
    done

    if (( has_python_marker )); then
        # Look for virtual environment in common locations
        local venv_paths=("$project_root/.venv" "$project_root/venv" "$project_root/env")

        for venv_path in "${venv_paths[@]}"; do
            if [[ -f "$venv_path/bin/activate" ]]; then
                echo "🐍 Activating Python virtual environment: ${venv_path:t}"
                source "$venv_path/bin/activate"
                break
            elif [[ -f "$venv_path/Scripts/activate" ]]; then
                # Windows support
                echo "🐍 Activating Python virtual environment: ${venv_path:t}"
                source "$venv_path/Scripts/activate"
                break
            fi
        done

        # Load .env file if present
        [[ -f "$project_root/.env" ]] && {
            echo "📄 Loading environment variables from .env"
            source "$project_root/.env"
        }
    fi

    # Load project-specific shell configuration
    [[ -f "$project_root/.zshrc.local" ]] && source "$project_root/.zshrc.local"
}

# Corresponding cleanup hook
off_project_hook() {
    local project_root="$1"
    shift
    local markers=("$@")

    # Show leave message (if enabled)
    if [[ "$HOOKIE_SHOW_LEAVING" != "0" ]]; then
        echo "👋 Left project: ${project_root:t}"
    fi

    # Deactivate Python virtual environment
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "🐍 Deactivating Python virtual environment"
        deactivate 2>/dev/null
    fi

    # Clear environment variables
    unset HOOKIE_CURRENT_PROJECT
    unset HOOKIE_PROJECT_ROOT
    unset HOOKIE_PROJECT_MARKERS_STRING

    # Clear internal state
    HOOKIE_CURRENT_PROJECT_DIR=""
    HOOKIE_CURRENT_PROJECT_MARKERS=()
}
```

### Simple Python Virtual Environment Example

For a more minimal approach, just focusing on Python projects:

```bash
on_project_hook() {
    local project_root="$1"
    shift
    local markers=("$@")

    # Standard setup
    export HOOKIE_CURRENT_PROJECT="${project_root:t}"
    export HOOKIE_PROJECT_ROOT="$project_root"
    typeset -g HOOKIE_PROJECT_MARKERS_STRING="${(j:, :)markers}"
    export HOOKIE_PROJECT_MARKERS_STRING

    echo "🚀 Entered project: ${project_root:t}"

    # Simple Python venv activation
    if [[ -f "$project_root/.venv/bin/activate" ]]; then
        echo "🐍 Activating .venv"
        source "$project_root/.venv/bin/activate"
    elif [[ -f "$project_root/venv/bin/activate" ]]; then
        echo "🐍 Activating venv"
        source "$project_root/venv/bin/activate"
    fi
}

off_project_hook() {
    local project_root="$1"
    echo "👋 Left project: ${project_root:t}"

    # Deactivate any active virtual environment
    [[ -n "$VIRTUAL_ENV" ]] && deactivate 2>/dev/null

    # Cleanup
    unset HOOKIE_CURRENT_PROJECT HOOKIE_PROJECT_ROOT HOOKIE_PROJECT_MARKERS_STRING
}
```

## Default Project Markers

The plugin detects projects by looking for these files and directories:

### Version Control

- `.git`, `.gitignore`, `.gitmodules`

### Python

- `pyproject.toml`, `requirements.txt`, `setup.py`, `setup.cfg`, `Pipfile`,
  `poetry.lock`, `.venv`, `venv`, `env`, `.python-version`, `tox.ini`, `pytest.ini`

### JavaScript/Node.js

- `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `.nvmrc`,
  `tsconfig.json`, `webpack.config.js`, `vite.config.js`, `.eslintrc.js`, `.prettierrc`,
  `jest.config.js`

### Other Languages

- **Rust**: `Cargo.toml`, `Cargo.lock`
- **Go**: `go.mod`, `go.sum`, `go.work`
- **Java**: `pom.xml`, `build.gradle`, `build.gradle.kts`
- **PHP**: `composer.json`, `composer.lock`
- **Ruby**: `Gemfile`, `Gemfile.lock`, `Rakefile`
- **Elixir**: `mix.exs`, `mix.lock`
- **Gleam**: `gleam.toml`
- **Deno**: `deno.json`, `deno.jsonc`
- **Swift**: `Package.swift`
- **Dart/Flutter**: `pubspec.yaml`

### Infrastructure & DevOps

- **Docker**: `Dockerfile`, `docker-compose.yml`, `.dockerignore`
- **Infrastructure**: `terraform`, `Vagrantfile`, `ansible`
- **CI/CD**: `.github`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci`

### Configuration & Documentation

- **Config**: `.env`, `config.toml`, `config.yaml`, `.editorconfig`
- **Docs**: `README.md`, `README.rst`, `LICENSE`, `CHANGELOG.md`, `docs`
- **IDE**: `.vscode`, `.idea`, `.vim`, `.nvim`

### Build Tools & Databases

- **Build**: `Makefile`, `CMakeLists.txt`, `gulpfile.js`, `webpack.config.js`
- **Database**: `schema.sql`, `migrations`, `alembic.ini`
- **Package Managers**: `Brewfile`, `Podfile`, `flake.nix`

*And many more! See the full list in the plugin source.*

## Default Blacklisted Paths

These paths are blacklisted by default (exact matches only) to prevent false positives:

- **System directories**: `/`, `/usr`, `/opt`, `/var`, `/etc`, `/tmp`
- **macOS system**: `/System`, `/Library`
- **User config**: `~/.config`, `~/.cache`, `~/.local`
- **Development tools**: `~/.oh-my-zsh`, `~/.zinit`, `~/.npm`, `~/.cargo`
- **User folders**: `~/Desktop`, `~/Downloads`, `~/Documents`

## Performance

- **Efficient Detection**: ~1-5ms overhead per directory change
- **Smart Caching**: Only triggers hooks when project context changes
- **Minimal File I/O**: Optimized file existence checks
- **No Background Processes**: All operations are synchronous and fast
- **Path Shortening**: Intelligent parent directory compression

## Advanced Features

### Plugin Structure

```bash
zsh-hookie-projects/
├── zsh-hookie-projects.plugin.zsh    # Main plugin file
├── functions/                        # Function directory
│   ├── _hookie_find_project_root     # Project detection logic
│   ├── _hookie_detect_markers        # Marker detection
│   ├── _hookie_check_project_change  # State management
│   ├── _hookie_is_path_allowed       # Path filtering
│   ├── on_project_hook               # Enter project hook
│   ├── off_project_hook              # Leave project hook
│   ├── prompt_hookie_dir             # PowerLevel10k directory segment
│   └── cd                            # Smart cd command
├── README.md                         # Documentation
└── LICENSE                           # MIT License
```

### Configuration Variables

```bash
# Path filtering
HOOKIE_BLACKLIST_PATHS=(...)      # Blocked directories
HOOKIE_WHITELIST_PATHS=(...)      # Allowed directories (optional)

# Project detection
HOOKIE_PROJECT_MARKERS=(...)      # File/directory markers

# Directory display colors
HOOKIE_DIR_PROJECT_COLOR=4        # Project path color
HOOKIE_DIR_SUBDIR_COLOR=6         # Subdirectory color
HOOKIE_DIR_DEFAULT_COLOR=4        # Non-project directory color

# Message control
HOOKIE_SHOW_ENTERING=1            # Show enter messages
HOOKIE_SHOW_LEAVING=1             # Show leave messages
HOOKIE_SHOW_CD_PROJECT_ROOT=1     # Show smart cd messages

# Behavior control
HOOKIE_DISABLE_SMART_CD=0         # Disable smart cd command
```

## Troubleshooting

### Plugin Not Loading

Make sure the plugin is properly loaded and functions are available:

```bash
# Check if functions are loaded
type prompt_hookie_dir
type _hookie_check_project_change

# Manually reload if needed
autoload -Uz prompt_hookie_dir
```

### Startup Delay

If the directory segment shows empty on first terminal startup, simply press Enter once.
This is a minor initialization timing issue with PowerLevel10k.

### Export Type Errors

If you see `inconsistent type for assignment` errors in custom hooks:

```bash
# Use this pattern in custom hooks:
typeset -g HOOKIE_PROJECT_MARKERS_STRING="${(j:, :)markers}"
export HOOKIE_PROJECT_MARKERS_STRING
```

### Debug Mode

Enable debug output to troubleshoot issues:

```bash
# Add to your hook functions temporarily
echo "DEBUG: Project root: $project_root"
echo "DEBUG: Markers: ${markers[@]}"
echo "DEBUG: PWD: $PWD"
```

## Contributing

Contributions are welcome! Please feel free to:

- Add support for new project markers
- Improve performance optimizations
- Fix bugs or edge cases
- Enhance documentation
- Add new PowerLevel10k segment features

## License

MIT License - see [LICENSE](LICENSE) file.

## Credits

Inspired by various zsh plugins and the need for a language-agnostic project detection
system. Built for developers who work with multiple programming languages and want
consistent project-aware shell behavior.

Special thanks to the PowerLevel10k project for providing the excellent prompt framework
that makes the `hookie_dir` segment possible.
