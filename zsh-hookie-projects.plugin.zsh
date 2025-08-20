#!/usr/bin/env zsh

# zsh-hookie-projects: Language-agnostic project detection with hooks
# Author: [Your Name]
# License: MIT

# Global state variables
typeset -g HOOKIE_CURRENT_PROJECT_DIR=""
typeset -ga HOOKIE_CURRENT_PROJECT_MARKERS=()

# Hookie-dir segment configuration (customizable in ~/.zshrc)
typeset -g HOOKIE_DIR_PARENT_COLOR=${HOOKIE_DIR_PARENT_COLOR:-240}     # Dark gray
typeset -g HOOKIE_DIR_PROJECT_COLOR=${HOOKIE_DIR_PROJECT_COLOR:-6}      # Cyan
typeset -g HOOKIE_DIR_SUBDIR_COLOR=${HOOKIE_DIR_SUBDIR_COLOR:-4}        # Blue
typeset -g HOOKIE_DIR_SEPARATOR_COLOR=${HOOKIE_DIR_SEPARATOR_COLOR:-240} # Dark gray
typeset -g HOOKIE_DIR_DEFAULT_COLOR=${HOOKIE_DIR_DEFAULT_COLOR:-4}       # Blue
typeset -g HOOKIE_DIR_SHORTEN_THRESHOLD=${HOOKIE_DIR_SHORTEN_THRESHOLD:-3} # When to start shortening

# Default project markers (customizable)
typeset -ga HOOKIE_PROJECT_MARKERS=(
    # Version Control
    '.git'
    '.gitignore'
    '.gitmodules'

    # Python
    'pyproject.toml'
    'requirements.txt'
    'setup.py'
    'setup.cfg'
    'Pipfile'
    'poetry.lock'
    '.venv'
    'venv'
    'env'
    '.python-version'
    'tox.ini'
    'pytest.ini'

    # Node.js/JavaScript
    'package.json'
    'package-lock.json'
    'yarn.lock'
    'pnpm-lock.yaml'
    '.nvmrc'
    'tsconfig.json'
    'webpack.config.js'
    'vite.config.js'
    'rollup.config.js'
    '.babelrc'
    '.eslintrc.js'
    '.eslintrc.json'
    '.prettierrc'
    'jest.config.js'

    # Rust
    'Cargo.toml'
    'Cargo.lock'

    # Go
    'go.mod'
    'go.sum'
    'go.work'

    # Java/JVM
    'pom.xml'
    'build.gradle'
    'build.gradle.kts'
    'gradle.properties'
    'settings.gradle'
    'build.sbt'          # Scala

    # C/C++
    'Makefile'
    'CMakeLists.txt'
    'configure.ac'
    'meson.build'
    'conanfile.txt'

    # PHP
    'composer.json'
    'composer.lock'
    'phpunit.xml'

    # Ruby
    'Gemfile'
    'Gemfile.lock'
    'Rakefile'
    '.ruby-version'

    # Elixir
    'mix.exs'
    'mix.lock'

    # Gleam
    'gleam.toml'

    # Deno
    'deno.json'
    'deno.jsonc'

    # Swift
    'Package.swift'

    # Kotlin
    'build.gradle.kts'

    # Mobile Development
    'pubspec.yaml'       # Flutter/Dart
    'android'            # Android project
    'ios'                # iOS project

    # Docker & Containers
    'Dockerfile'
    'docker-compose.yml'
    'docker-compose.yaml'
    '.dockerignore'
    'Containerfile'

    # Infrastructure as Code
    'terraform'
    'Terrafile'
    'ansible'
    'k8s'
    'kubernetes'
    'helm'
    'Vagrantfile'

    # CI/CD
    '.github'
    '.gitlab-ci.yml'
    '.travis.yml'
    'Jenkinsfile'
    '.circleci'
    'azure-pipelines.yml'
    '.buildkite'

    # Configuration Files
    '.env'
    '.env.local'
    '.env.example'
    'config.toml'
    'config.yaml'
    'config.yml'
    '.editorconfig'

    # Documentation
    'README.md'
    'README.rst'
    'README.txt'
    'CHANGELOG.md'
    'CHANGELOG.rst'
    'LICENSE'
    'LICENSE.txt'
    'LICENSE.md'
    'CONTRIBUTING.md'
    'CODE_OF_CONDUCT.md'
    'docs'

    # IDE/Editor Configuration
    '.vscode'
    '.idea'
    '.vim'
    '.nvim'
    '.emacs.d'

    # Linting & Formatting
    '.flake8'
    '.black'
    'mypy.ini'
    'pylint.rc'
    'ruff.toml'
    '.isort.cfg'

    # Database
    'schema.sql'
    'migrations'
    'seeds'
    'alembic.ini'        # Python SQLAlchemy
    'knexfile.js'        # Node.js Knex migrations

    # Task Runners & Build Tools
    'gulpfile.js'
    'Gruntfile.js'
    'webpack.config.js'
    'babel.config.js'
    'postcss.config.js'
    'tailwind.config.js'

    # Package Managers
    'Brewfile'           # Homebrew
    'Pipfile'            # Pipenv
    'Podfile'            # CocoaPods (iOS)
    'flake.nix'          # Nix

    # Game Development
    'project.godot'      # Godot
    'Assets'             # Unity

    # Data Science/ML
    'requirements-dev.txt'
    'environment.yml'    # Conda
    'notebook.ipynb'
    'model.pkl'

    # Web Frameworks
    'next.config.js'     # Next.js
    'nuxt.config.js'     # Nuxt.js
    'svelte.config.js'   # Svelte
    'astro.config.mjs'   # Astro
    'remix.config.js'    # Remix

    # Static Site Generators
    '_config.yml'        # Jekyll
    'hugo.toml'          # Hugo
    'gatsby-config.js'   # Gatsby

    # Monitoring & Observability
    'prometheus.yml'
    'grafana'
    'jaeger'

    # Custom
    '.project-root'
)

# Path filtering configuration
typeset -ga HOOKIE_BLACKLIST_PATHS=(
    "$HOME"                    # Home directory
    "/"                        # Root directory
    "/usr"                     # System directories
    "/usr/local"
    "/usr/share"
    "/opt"
    "/var"
    "/etc"
    "/tmp"                     # Temporary directories
    "/System"                  # macOS system
    "/Library"                 # macOS system
    "$HOME/.local"             # User local directories
    "$HOME/.config"            # User config directories
    "$HOME/.cache"
    "$HOME/.oh-my-zsh"         # Oh My Zsh directory
    "$HOME/.zinit"             # Zinit directory
    "$HOME/.zsh"               # Zsh directories
)

# Optional: whitelist only specific directories (empty = disabled)
typeset -ga HOOKIE_WHITELIST_PATHS=(
    # Examples (uncomment to enable whitelist mode):
    # "$HOME/projects"
    # "/workspace"
)

# Load all functions
local plugin_dir="${0:A:h}"
fpath=("$plugin_dir/functions" $fpath)

# Auto-load functions
autoload -Uz _hookie_find_project_root
autoload -Uz _hookie_detect_markers
autoload -Uz _hookie_check_project_change
autoload -Uz _hookie_is_path_allowed
autoload -Uz on_project_hook
autoload -Uz off_project_hook
autoload -Uz prompt_hookie_dir
autoload -Uz cd

# Hook into directory changes
chpwd_functions+=(_hookie_check_project_change)

# Initialize on plugin load
_hookie_check_project_change
