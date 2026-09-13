\# Data Warehouse Migration Reconciliation



A project for automating source vs. target validation during a warehouse migration.



This project was inspired by a BigQuery-to-Snowflake migration validation project I undertook professionally. At that time, I used SQL to aggregate equivalent data in each warehouse and manually reconciled the results in Excel. I built this project to explore how that process could be made more repeatable and scalable.



\## How It Works



For each dataset, the workflow is:



1\. Stage source and target data in Snowflake.

2\. Use dbt models to calculate equivalent business metrics.

3\. Reconcile source vs. target results at defined business grains.

4\. Run quality checks for issues such as duplicates and null values.

5\. Produce a unified PASS/FAIL reconciliation report.

6\. Store results in Snowflake with run timestamps for historical tracking.



A YAML configuration identifies the datasets to process and a Python runner orchestrates the dbt workflow.



\## Example Datasets



\*\*Orders\*\* — reconciles order counts, quantities, and revenue by date and channel.



\*\*Customers\*\* — reconciles customer counts and lifetime value by region and customer status.



Defects are intentionally included in the datasets to demonstrate detection of issues such as missing records, duplicates, null values, and metric discrepancies.



\## Technology



SQL · dbt · Snowflake · Python · YAML



\## Run



From the project root:



```powershell

python run\_reconciliation.py

```



The command runs the pipelines, displays the validation report in the terminal, and saves the results to Snowflake for historical tracking.



