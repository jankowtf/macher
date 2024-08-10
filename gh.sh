#!/bin/bash

# Set variables
ORIGINAL_REPO="frdel/agent-zero"
FORKED_REPO="jankowtf/agent-zero"
NEW_REPO_NAME="macher"
GITHUB_USERNAME="jankowtf"

# Ask user for run type
echo "Choose run type:"
echo "1. Create new repository and directory (default)"
echo "2. Initialize in existing directory"
read -p "Enter choice [1/2]: " run_type

if [ "$run_type" != "2" ]; then
    # Create new repository and clone it
    gh repo create $NEW_REPO_NAME --public --clone
    cd $NEW_REPO_NAME
else
    # Create remote repository without cloning
    gh repo create $NEW_REPO_NAME --public
    # Initialize git in the current directory
    git init
    git remote add origin https://github.com/$GITHUB_USERNAME/$NEW_REPO_NAME.git
fi

# Initialize poetry project
poetry init -n

# Set up src layout
mkdir -p src/$NEW_REPO_NAME/{adapters,extensions,wrappers}
touch src/$NEW_REPO_NAME/__init__.py

# Add forked repo as submodule
git submodule add https://github.com/$FORKED_REPO.git src/original_package

# Add original repo as remote to the submodule
cd src/original_package
git remote add upstream https://github.com/$ORIGINAL_REPO.git
cd ../..
# Create test directory
mkdir -p tests
touch tests/__init__.py

# Create docs directory
mkdir docs
echo "# Extended Package Documentation" > docs/index.md

# Update pyproject.toml
cat << EOF >> pyproject.toml

[tool.poetry.dependencies]
python = "^3.8"

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"

[tool.poetry.packages]
include = [
    { include = "$NEW_REPO_NAME", from = "src" },
    { include = "original_package", from = "src" },
]
EOF

# Create README.md
echo "# $NEW_REPO_NAME" > README.md
echo "Extended functionality for $ORIGINAL_REPO" >> README.md

# Create .gitignore
cat << EOF > .gitignore
__pycache__
*.pyc
.pytest_cache
.venv
EOF

# Initial commit
git add .
git commit -m "Initial project structure"

# Push to GitHub
git push -u origin main

echo "Repository setup complete. Navigate to $NEW_REPO_NAME to start development."