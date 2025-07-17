#!/bin/bash

echo "🦎 Installing KameleonCI Deployment Workflow..."

# Function to download a file with overwrite confirmation
download_file() {
    local url="$1"
    local destination="$2"
    local description="$3"

    if [ -f "$destination" ]; then
        echo "⚠️  $description already exists at $destination"
        echo "Do you want to overwrite it? [y/N]"
        read -r overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            echo "ℹ️  Skipping download of $description"
            return
        fi
    fi

    echo "📥 Downloading $description..."
    curl -o "$destination" "$url"
    echo "✅ Downloaded $description to $destination"
}

# Ensure we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: Must be run from the root of a git repository"
    exit 1
fi

# Create workflows directory if it doesn't exist
mkdir -p .github/workflows

# Download the workflow file
download_file \
    "https://raw.githubusercontent.com/kalamuna/kameleonci/main/.github/workflows/kameleonci.yml" \
    ".github/workflows/kameleonci.yml" \
    "workflow file"

# Ask about build process
echo ""
echo "Do you need to build assets (Composer/npm) in GitHub Actions?"
echo ""
echo "Recommended settings by host:"
echo "- Pantheon: No (Pantheon handles builds via their infrastructure)"
echo "- Platform.sh: Maybe (Composer: no, Node.js: yes by default)"
echo "- Acquia: Yes (both Composer and Node.js builds happen in Actions)"
echo "- Other hosts: Depends on your host's build capabilities"
echo ""
echo "Build in GitHub Actions? [y/N]"
read -r needs_build

if [[ $needs_build =~ ^[Yy]$ ]]; then
    download_file \
        "https://raw.githubusercontent.com/kalamuna/kameleonci/main/.gitignore-deploy" \
        ".gitignore-deploy" \
        ".gitignore-deploy file"
    echo "ℹ️  Review and customize .gitignore-deploy for your project's build artifacts"
else
    echo "ℹ️  Skipping .gitignore-deploy as it's not needed without build processes"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Configure your repository variables and secrets in GitHub:"
echo "   Go to your repository's Settings → Secrets and variables → Actions"
echo "   Then add these required variables and secrets:"
echo ""
echo "   Required for all:"
echo "   - DEPLOY_REPO: Git URL of your hosting provider's repository"
echo "   - GIT_NAME: Git user name for commits"
echo "   - GIT_EMAIL: Git user email"
echo "   - SSH_CONFIG: SSH configuration (add as a variable)"
echo "   - SSH_KEY: SSH private key (add as a secret)"
echo ""
echo "   For Pantheon sites also add:"
echo "   - PANTHEON_SITE_NAME: Your Pantheon site name (add as a variable)"
echo "   - PANTHEON_MACHINE_TOKEN: Terminus machine token (add as a secret)"
echo ""
if [[ $needs_build =~ ^[Yy]$ ]]; then
    echo "2. Review and customize .gitignore-deploy for your build artifacts"
    echo "3. Push your code to trigger the workflow"
else
    echo "2. Push your code to trigger the workflow"
fi
echo ""

echo "📚 Full documentation: https://github.com/kalamuna/kameleonci"

# Delete this install script
SCRIPT_PATH="$(realpath "$0")"
echo "🧹 Removing installer script: $SCRIPT_PATH"
rm -f "$SCRIPT_PATH"
