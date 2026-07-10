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
- Node.js 20+ (for Evidence.dev dashboard)
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

3. Install Python dependencies
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
dbt debug    # verify connection is working
dbt seed     # load CSV files into DuckDB (only needed on first setup or when CSVs change)
dbt run      # build all models
dbt test     # run data quality tests
```

7. Run Dagster orchestration
```bash
cd ..
dagster dev -f dagster_pipeline.py
```
Open http://127.0.0.1:3000 to view the Dagster UI

8. Run Evidence.dev dashboard
```bash
cd evidence_dashboard
npm install
npm run sources
npm run dev
```
Open http://localhost:3000 to view the dashboard

## Common Commands

| Command | What it does | When to use |
|---|---|---|
| `dbt debug` | Checks connection and config | First setup, diagnosing issues |
| `dbt seed` | Loads CSV files into DuckDB | First setup or when CSVs change |
| `dbt run` | Builds all models | Every time you change a model |
| `dbt run --select model_name` | Builds one specific model | When working on a single model |
| `dbt test` | Runs data quality tests | After building models |
| `dbt docs generate && dbt docs serve` | Opens documentation site | To view model docs and lineage |

## Status
🚧 In progress
