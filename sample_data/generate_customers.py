import pandas as pd
import random
from pathlib import Path

random.seed(42)

output_dir = Path(__file__).parent
source_dir = output_dir / "source"
target_dir = output_dir / "target"

source_dir.mkdir(parents=True, exist_ok=True)
target_dir.mkdir(parents=True, exist_ok=True)

regions = ["northeast", "south", "midwest", "west"]
statuses = ["active", "inactive", "churned"]
segments = ["standard", "premium", "enterprise"]

customers = []

for customer_id in range(1, 2001):
    customers.append(
        {
            "customer_id": customer_id,
            "signup_date": pd.Timestamp("2022-01-01")
            + pd.Timedelta(days=random.randint(0, 1459)),
            "region": random.choice(regions),
            "customer_status": random.choice(statuses),
            "customer_segment": random.choice(segments),
            "lifetime_value": round(random.uniform(50, 5000), 2),
        }
    )

source = pd.DataFrame(customers)

# Simulate the migrated target.
target = source.copy()

# 5 customers missing from target.
target = target.iloc[5:].copy()

# 3 status mismatches.
status_indices = target.index[:3]
for idx in status_indices:
    current_status = target.loc[idx, "customer_status"]
    target.loc[idx, "customer_status"] = next(
        status for status in statuses if status != current_status
    )

# 4 lifetime-value mismatches.
value_indices = target.index[3:7]
target.loc[value_indices, "lifetime_value"] += 100

# 2 null regions.
region_indices = target.index[7:9]
target.loc[region_indices, "region"] = None

# 2 duplicate customer records.
duplicates = target.iloc[9:11].copy()
target = pd.concat([target, duplicates], ignore_index=True)

source.to_csv(source_dir / "customers.csv", index=False)
target.to_csv(target_dir / "customers.csv", index=False)

print("Synthetic customer migration data created.")
print(f"Source rows: {len(source):,}")
print(f"Target rows: {len(target):,}")