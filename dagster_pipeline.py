from dagster import Definitions, ScheduleDefinition
from dagster_dbt import DbtProject, DbtCliResource, dbt_assets
from pathlib import Path

# Pointing Dagster to project directory and manifest file
dbt_project = DbtProject(
    project_dir=Path(__file__).parent / "olist_pipeline",
)

@dbt_assets(manifest=dbt_project.manifest_path)
def olist_dbt_assets(context, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

# Schedule — runs the full pipeline every day at 6am
daily_schedule = ScheduleDefinition(
    name="daily_olist_pipeline",
    cron_schedule="0 6 * * *",
    job_name="__ASSET_JOB",
    execution_timezone="America/Chicago",
)

defs = Definitions(
    assets=[olist_dbt_assets],
    schedules=[daily_schedule],
    resources={
        "dbt": DbtCliResource(
            project_dir=dbt_project,
            profiles_dir=str(Path.home() / ".dbt"),
        ),
    },
)