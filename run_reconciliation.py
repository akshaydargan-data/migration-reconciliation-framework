import glob
import subprocess
import sys
import yaml

config_paths = glob.glob("configs/*.yml")
dbt_project = "dbt/migration_reconciliation"

for path in config_paths:
    with open(path, "r") as file:
        config = yaml.safe_load(file)

    dataset_name = config["dataset"]
    reconciliation_selection = f"+{dataset_name}_reconciliation"

    print(f"\nRunning reconciliation for {dataset_name}...")

    subprocess.run(
        [
            sys.executable,
            "-m",
            "dbt.cli.main",
            "run",
            "--select",
            reconciliation_selection
        ],
        cwd=dbt_project,
        check=True
    )

print("\nBuilding and saving reconciliation report...")

subprocess.run(
    [
        sys.executable,
        "-m",
        "dbt.cli.main",
        "run",
        "--select",
        "reconciliation_history"
    ],
    cwd=dbt_project,
    check=True
)

print("\nRECONCILIATION RESULTS\n")

subprocess.run(
    [
        sys.executable,
        "-m",
        "dbt.cli.main",
        "show",
        "--select",
        "reconciliation_report",
        "--limit",
        "100"
    ],
    cwd=dbt_project,
    check=True
)

print("\nReconciliation complete. Results saved to Snowflake.")