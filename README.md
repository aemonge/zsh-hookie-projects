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
- **🎨 PowerLevel10k Integration**: Built-in environment variables for prompt
  customization
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
❯ cd ~/my-python-project
🚀 Entered project: my-python-project (pyproject.toml, .git, README.md)

❯ cd ../my-rust-project
👋 Left project: my-python-project
🚀 Entered project: my-rust-project (Cargo.toml, .git)

❯ cd ~
👋 Left project: my-rust-project
```

## Environment Variables

The plugin automatically sets these environment variables when entering projects:

- **`HOOKIE_CURRENT_PROJECT`** - Project name (e.g., `my-project`)
- **`HOOKIE_PROJECT_ROOT`** - Full path to project root
- **`HOOKIE_PROJECT_MARKERS_STRING`** - Comma-separated detected markers

```bash
❯ echo $HOOKIE_CURRENT_PROJECT
my-python-app

❯ echo $HOOKIE_PROJECT_ROOT
/home/user/projects/my-python-app

❯ echo $HOOKIE_PROJECT_MARKERS_STRING
.git, pyproject.toml, README.md
```

## PowerLevel10k Integration

Add project information to your PowerLevel10k prompt:

### Simple Integration

Add to your `~/.p10k.zsh`:

```bash
# Add to your prompt elements
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(hookie_project)

# Simple project segment
function prompt_hookie_project() {
    [[ -n "$HOOKIE_CURRENT_PROJECT" ]] && p10k segment -f 6 -t "$HOOKIE_CURRENT_PROJECT"
}
```

### With Icon

```bash
function prompt_hookie_project() {
    [[ -n "$HOOKIE_CURRENT_PROJECT" ]] && p10k segment -f 6 -i "●" -t "$HOOKIE_CURRENT_PROJECT"
}
```

### Dynamic Icons by Project Type

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

These paths are blacklisted by default to prevent false positives:

- System directories: `/`, `/usr`, `/opt`, `/var`, `/etc`, `/tmp`
- macOS system: `/System`, `/Library`
- User config: `~/.config`, `~/.cache`, `~/.local`
- Development tools: `~/.oh-my-zsh`, `~/.zinit`, `~/.npm`, `~/.cargo`
- User folders: `~/Desktop`, `~/Downloads`, `~/Documents`

## Performance

- **Efficient Detection**: ~1-5ms overhead per directory change
- **Smart Caching**: Only triggers hooks when project context changes
- **Minimal File I/O**: Optimized file existence checks
- **No Background Processes**: All operations are synchronous and fast

## Troubleshooting

### Export Type Errors

If you see `inconsistent type for assignment` errors:

```bash
# In your custom hook, use:
typeset -g HOOKIE_PROJECT_MARKERS_STRING="${(j:, :)markers}"
export HOOKIE_PROJECT_MARKERS_STRING
```

### Plugin Not Loading

Make sure the plugin is properly structured:

```bash
zsh-hookie-projects/
├── zsh-hookie-projects.plugin.zsh
├── functions/
│   ├── _hookie_find_project_root
│   ├── _hookie_detect_markers
│   ├── _hookie_check_project_change
│   ├── _hookie_is_path_allowed
│   ├── on_project_hook
│   └── off_project_hook
└── README.md
```

### Debug Mode

Enable debug output:

```bash
# Add to your hook functions
echo "DEBUG: Project root: $project_root"
echo "DEBUG: Markers: ${markers[@]}"
```

## Contributing

Contributions are welcome! Please feel free to:

- Add support for new project markers
- Improve performance optimizations
- Fix bugs or edge cases
- Enhance documentation

## License

MIT License - see [LICENSE](LICENSE) file.

## Credits

Inspired by various zsh plugins and the need for a language-agnostic project detection
system. Built for developers who work with multiple programming languages and want
consistent project-aware shell behavior.
