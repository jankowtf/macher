import click
import subprocess


def parse_requirements(filename):
    with open(filename, "r") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                yield line


def add_dependency(dep):
    subprocess.run(["poetry", "add", dep], check=True)


@click.command()
@click.option(
    "--req-file",
    default="src/original_package/requirements.txt",
    help="Path to requirements.txt",
)
def sync_dependencies(req_file):
    """Sync dependencies from requirements.txt to Poetry"""
    for req in parse_requirements(req_file):
        try:
            add_dependency(req)
            click.echo(f"Added {req}")
        except subprocess.CalledProcessError:
            click.echo(f"Failed to add {req}")
    click.echo("Dependency sync complete. Run 'poetry lock' to update the lock file.")
