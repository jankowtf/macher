import click
from .sync_dependencies import sync_dependencies
from .sync_original import sync_original, update_submodule


@click.group()
def cli():
    pass


cli.add_command(sync_dependencies)
cli.add_command(update_submodule)
cli.add_command(sync_original)
