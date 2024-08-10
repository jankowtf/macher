import click
import os
import shutil
import subprocess


def _update_submodule():
    submodule_path = "src/original_package"
    try:
        subprocess.run(
            ["git", "submodule", "update", "--remote", submodule_path],
            check=True,
        )
        click.echo(f"Submodule at {submodule_path} updated successfully.")
    except subprocess.CalledProcessError:
        click.echo(f"Failed to update submodule at {submodule_path}")


def _sync_original():
    submodule_path = "src/original_package"
    target_path = "src/macher/original"

    # Ensure target directory exists
    os.makedirs(target_path, exist_ok=True)

    # Copy contents
    for item in os.listdir(submodule_path):
        s = os.path.join(submodule_path, item)
        d = os.path.join(target_path, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, dirs_exist_ok=True)
        else:
            shutil.copy2(s, d)

    click.echo(
        f"Original package content synced successfully from {submodule_path} to {target_path}"
    )


@click.command()
def update_submodule():
    """Update the original package submodule"""
    _update_submodule()


@click.command()
@click.option(
    "--update-submodule", is_flag=True, help="Update the submodule before syncing"
)
def sync_original(update_submodule):
    """Sync original package content"""
    if update_submodule:
        _update_submodule()
    _sync_original()
