# Olist Analytics Pipeline

End-to-end analytics engineering project built on 100,000 real Brazilian 
marketplace transactions. Identifies products with competing sellers and 
surfaces which sellers deliver the best value — not just the lowest price.

## The Finding

The same product sold by 8 different sellers ranged from 185 to 349 BRL — 
an 89% price difference. The cheapest seller had the worst rating (3.16 stars) 
and slowest delivery (17 days). The most expensive seller had a perfect 5.0 
rating and delivered in 5 days.

Cheapest ≠ best value. This pipeline surfaces that gap automatically.

## Stack
- **DuckDB** — local analytical database
- **dbt** — data transformation and modeling with tests and documentation
- **Dagster** — pipeline orchestration with daily schedule
- **Evidence.dev** — live dashboard
- **Anthropic Claude API** — AI-generated seller intelligence briefs

## Project Structure\
olist_pipeline/
├── models/
│   ├── staging/        # Light cleaning, one model per source table
│   ├── intermediate/   # Joined models, business logic
│   └── marts/          # Final business-facing tables
├── seeds/              # Raw CSV files (not committed to GitHub)
└── dbt_project.yml
dagster_pipeline.py                    # Dagster orchestration
evidence_dashboard/                    # Evidence.dev dashboard
seller_competition_ai_analysis.ipynb   # AI seller intelligence notebook

## Key Technical Decisions
- **40 dbt data quality tests** — caught a real issue: one delivered order 
  with no payment record, fixed with coalesce
- **Three-layer dbt architecture** — staging (clean), intermediate (join), 
  marts (business logic) keeps transformation logic separate and reusable
- **Seller ranking without arbitrary weights** — three independent dimensions 
  (price, delivery, quality) let marketplace operators apply their own priorities
- **Dynamic token budgeting** — input tokens counted exactly, output tokens 
  derived from prompt word constraints, actual cost tracked from API response

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
dbt debug    # verify connection
dbt seed     # load CSV files into DuckDB
dbt run      # build all models
dbt test     # run 40 data quality tests
```

7. Run Dagster orchestration
```bash
cd ..
dagster dev -f dagster_pipeline.py
```
Open http://127.0.0.1:3000

8. Run Evidence.dev dashboard
```bash
cd evidence_dashboard
npm install
npm run sources
npm run dev
```
Open http://localhost:3000

9. Run AI seller intelligence notebook
Open `seller_competition_ai_analysis.ipynb` in VS Code or Jupyter.
Add your Anthropic API key to a `.env` file: `ANTHROPIC_API_KEY=your-key`

## Common Commands

| Command | What it does | When to use |
|---|---|---|
| `dbt debug` | Checks connection and config | First setup |
| `dbt seed` | Loads CSV files into DuckDB | First setup or CSV changes |
| `dbt run` | Builds all models | Every model change |
| `dbt test` | Runs data quality tests | After building models |
| `dbt docs generate && dbt docs serve` | Opens documentation site | To view lineage |

## Status
🚧 In progress