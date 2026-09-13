\# Automated Data Warehouse Migration Reconciliation Framework



A SQL- and dbt-based framework for validating data consistency during warehouse migrations.



This project was inspired by a real BigQuery-to-Snowflake migration validation problem I encountered professionally. In that work, I validated equivalent outputs across the two warehouses using aggregate SQL queries and manual Excel-based reconciliation. That process worked, but it was difficult to scale across many datasets and validation checks.



I built this project to explore how that workflow could be made more systematic and automated using dbt and Snowflake.



\## What the Project Does



The framework compares source and target datasets representing a warehouse migration.



For each dataset it:



1\. Loads source and target data into Snowflake.

2\. Standardizes the data through staging models.

3\. Calculates and compares business-level aggregates.

4\. Reconciles source vs. target results.

5\. Flags discrepancies as PASS or FAIL.

6\. Uses dbt data tests to identify dataset-level quality problems.



The target data intentionally contains defects so that the validation logic can demonstrate how different issues are detected.



\## Current Architecture



```text

Synthetic Source / Target Data

&#x20;           |

&#x20;        dbt seeds

&#x20;           |

&#x20;      Staging Models

&#x20;           |

&#x20;  Intermediate Summaries

&#x20;           |

&#x20;  Reconciliation Models

&#x20;           |

&#x20;      PASS / FAIL



\## Orders Reconciliation



The orders dataset contains 5,000 source records. The target dataset includes defects such as:



\- Missing records

\- Duplicate records

\- Null dimension values

\- Revenue discrepancies

\- Product mismatches



The reconciliation compares source and target results at the `order\_date + channel` level using:



\- Order count

\- Quantity

\- Revenue



\## Customers Reconciliation



The customers dataset contains 2,000 source records. The target dataset includes defects such as:



\- Missing customers

\- Duplicate records

\- Null regions

\- Customer status changes

\- Lifetime-value discrepancies



The reconciliation compares source and target results at the `region + customer\_status` level using:



\- Customer count

\- Total lifetime value

