# 🦎 KameleonCI

[View the KameleonCI Drupal GovCon Presentation (PDF)](presentations/KameleonCI_%20One-size-fits-most%20GitHub%20Actions%20for%20Drupal.pdf)



A versatile GitHub Actions workflow for deploying Drupal projects to multiple hosting platforms.

## Quick Install

Run these commands in the root directory of your Drupal project's Git repository:

```bash
curl -O https://raw.githubusercontent.com/kalamuna/kameleonci/main/install.sh
chmod +x install.sh
./install.sh
```


> **Important:** On the first push, KameleonCI will perform a force push to ensure the contents of both repositories match. After a successful initial workflow run, a file named `.kameleon-initialized` will be committed to the repo. From then on, force push will be disabled and only safe pushes will be used.

> **Warning:** The initial force push will overwrite any files in the remote repository with the contents of your local repository. Make sure you want to replace the remote contents before proceeding.

The installation script will:
- Create the necessary `.github/workflows` directory
- Install the workflow file (with confirmation if it already exists)
- Optionally download `.gitignore-deploy` if you need to build assets in GitHub Actions (with confirmation if it already exists)
- Guide you through the next steps

> **Note**: The `.gitignore-deploy` file is only needed if you're building assets (Composer/npm) in GitHub Actions. The installer will ask if you need this feature

## Features

- 🎯 **Universal Deployment**: Deploy to Pantheon, Platform.sh, or Acquia with a single workflow
- 🔍 **Smart Host Detection**: Automatically configures settings based on your hosting platform
- 🌿 **Branch Management**: Smart primary branch handling and Pantheon multidev support
- 🏗️ **Flexible Structure**: Supports different docroot configurations (web vs docroot)
- 🛠️ **Build Process**: Integrated Composer and Node.js build support
- 🔄 **PR Integration**: Comprehensive pull request handling with environment provisioning
- ⚙️ **Universal Support**: Override system enables support for any Git-based Drupal host

## Setup

1. Run the installation script (see Quick Install section above)
2. Configure the required repository variables and secrets in your GitHub repository:
   - Go to your repository's Settings → Secrets and variables → Actions
   - Add the required variables and secrets listed below
3. Push your code and let KameleonCI handle the deployment!

## Configuration

### Required Repository Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DEPLOY_REPO` | Git URL of your hosting provider's repository | `ssh://codeserver.dev.xxx@codeserver.dev.xxx.drush.in:2222/~/repository.git` |
| `GIT_NAME` | Git user name for commits during deployment | `Deployment Bot` |
| `GIT_EMAIL` | Git user email for commits | `deploy@example.com` |
| `SSH_CONFIG` | SSH configuration for your hosting provider | See SSH Configuration section below |
| `PANTHEON_SITE_NAME` | (Pantheon only) Your Pantheon site name | `my-site` |

### Required Repository Secrets

| Secret | Description |
|--------|-------------|
| `SSH_KEY` | SSH private key for Git operations |
| `PANTHEON_MACHINE_TOKEN` | (Pantheon only) Terminus machine token |

### SSH Configuration Examples

Configure your `SSH_CONFIG` variable. Here is an example that includes the default supported platforms and a space for adding one:

#### Pantheon
```bash
# Pantheon
Host *.drush.in
    StrictHostKeyChecking no
    # Prevent multidev timeouts
    ServerAliveInterval 30

# Platform.sh
Host *.platform.sh
    StrictHostKeyChecking no

# Acquia
Host *.hosting.acquia.com
    StrictHostKeyChecking no

# Custom Host
# Example for a custom Git host
# Host git.example.com
#     StrictHostKeyChecking no
#     # Add any additional SSH options needed
```

### Override Options

The workflow includes a flexible override system that allows you to customize any automatically detected settings. This enables support for any Git-based Drupal hosting platform, not just the pre-configured ones. You can override default settings by editing the `Define Overrides` step in the workflow:

```yaml
HOST=''              # Force specific host type (pantheon, platform, acquia)
HOST_DOCROOT=''      # Override docroot path (e.g., 'web' or 'docroot')
CI_COMPOSER=''       # Enable/disable Composer build
CI_NODE=''          # Enable/disable Node.js build
TERMINUS=''         # Enable/disable Terminus commands
REMOTE_PRIMARY=''   # Set primary branch name (e.g., 'main' or 'master')
MULTIDEV=''         # Enable/disable multidev environments (Pantheon-specific)
NODE_TESTS=''       # Enable/disable Node.js tests
```

Each host is pre-configured with sensible defaults, but these can all be overridden to match your specific requirements. This flexibility means you can adapt the workflow for custom hosting setups or other Drupal hosting providers not included in the automatic detection.

### Host-Specific Features

#### Pantheon
- Automatic multidev environment creation/deletion (Pantheon-specific feature)
- Branch name validation for multidev compatibility
- PR comments with environment URLs
- Smart environment initialization from live/test/dev
- Uses `master` as the primary branch

#### Platform.sh
- Composer-free deployment process
- Node.js build support
- Uses `master` as the primary branch (configurable in Platform.sh)
- Uses `web` as the docroot

#### Acquia
- Full Composer + Node.js build process
- Uses `docroot` instead of `web` (maintaining Acquia's standard structure)
- Uses `main` as the primary branch

#### Other Hosts
- Support for any Git-based Drupal hosting through override options
- Configure custom docroot paths
- Specify primary branch names
- Enable/disable build steps as needed

## Requirements

- GitHub repository with Actions enabled
- Access to one of the supported hosting providers:
  - Pantheon
  - Platform.sh
  - Acquia
- SSH key access to hosting Git repository
- For Pantheon: Terminus machine token

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)
