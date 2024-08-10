#!/bin/bash

# Set variables
ORIGINAL_REPO="frdel/agent-zero"
FORKED_REPO="jankowtf/agent-zero"
NEW_REPO_NAME="macher"
GITHUB_USERNAME="jankowtf"

# Create new repository
gh repo create $NEW_REPO_NAME --public --clone

# Navigate to the new repository
cd $NEW_REPO_NAME

# Initialize poetry project
poetry init -n

# Set up src layout
mkdir -p src/$NEW_REPO_NAME/{adapters,extensions,wrappers}
touch src/$NEW_REPO_NAME/__init__.py

# Add original repo as submodule
# git submodule add https://github.com/$ORIGINAL_REPO.git src/original_package

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