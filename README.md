# Olist Analytics Pipeline

End-to-end analytics engineering project built with DuckDB, dbt, Dagster, and Evidence.dev on the Brazilian e-commerce Olist dataset. Includes a RAG-based AI layer for querying dbt model documentation using natural language.

## Stack
- **DuckDB** — local analytical database
- **dbt** — data transformation and modeling
- **Dagster** — pipeline orchestration
- **Evidence.dev** — dashboard
- **Anthropic Claude API** — RAG-based documentation Q&A

## Project Structure\
olist_pipeline/

├── models/

│   ├── staging/        # Light cleaning, one model per source table

│   ├── intermediate/   # Joined models, business logic

│   └── marts/          # Final business-facing tables

├── seeds/              # Raw CSV files (not committed to GitHub)

└── dbt_project.yml

## Setup

**Requirements**
- Python 3.11.9
- Git

**Steps**

1. Clone the repository
```bash
git clone https://github.com/p16996/olist-analytics-pipeline.git
cd olist-analytics-pipeline
```

2. Create and activate virtual environment
```bash
py -3.11 -m venv venv
venv\Scripts\activate
```

3. Install dependencies
```bash
pip install -r requirements.txt
```

4. Download Olist dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place all CSV files in `olist_pipeline/seeds/`

5. Create dbt profile at `C:\Users\<username>\.dbt\profiles.yml`
```yaml
olist_pipeline:
  outputs:
    dev:
      type: duckdb
      path: "<full path to project>\olist_pipeline\dev.duckdb"
      threads: 1
    prod:
      type: duckdb
      path: "<full path to project>\olist_pipeline\prod.duckdb"
      threads: 4
  target: dev
```

6. Load raw data and run models
```bash
cd olist_pipeline
dbt seed
dbt run
```

## Status
🚧 In progress