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
- **Anthropic Claude API** — AI seller intelligence briefs + automated dbt documentation

## Project Structure
```
olist_pipeline/
├── models/
│   ├── staging/        # Light cleaning, one model per source table (9 models)
│   ├── intermediate/   # Joined models, business logic (2 models)
│   └── marts/          # Final business-facing tables (4 models)
├── seeds/              # Raw CSV files (not committed to GitHub)
└── dbt_project.yml
dagster_pipeline.py                    # Dagster orchestration with daily schedule
evidence_dashboard/                    # Evidence.dev dashboard (3 pages)
seller_competition_ai_analysis.ipynb   # AI seller intelligence brief generator
generate_dbt_docs.ipynb               # AI-powered dbt documentation generator
```

## AI Features

### 1. Seller Intelligence Brief
Given a product with multiple competing sellers, generates a plain-English 
brief that a marketplace operator can act on immediately:

- Which seller offers best overall value and why
- Which seller is most at risk of damaging platform reputation
- Specific recommendation for the operator

Uses dynamic token budgeting — input tokens counted exactly before each call, 
output budget derived from prompt word constraints, actual cost tracked from 
API response metadata.

**Cost per brief:** ~$0.006

### 2. AI-Powered dbt Documentation Generator
Automatically generates model and column descriptions for every dbt model 
by reading the SQL file, querying DuckDB for actual column names and types, 
and sending both to Claude API.

Claude returns plain text descriptions. Python parses the response and writes 
directly into existing YAML files — preserving all dbt tests while updating 
descriptions. No JSON parsing errors possible.

**15 models documented in one run for $0.07 total.**

Token efficiency: actual output was 40% less than estimated because 
plain text is more token-efficient than JSON formatting.

## Key Technical Decisions

- **40 dbt data quality tests** — caught a real issue: one delivered order 
  with no payment record, fixed with coalesce
- **Three-layer dbt architecture** — staging (clean), intermediate (join), 
  marts (business logic) keeps transformation logic separate and reusable
- **Seller ranking without arbitrary weights** — three independent dimensions 
  (price, delivery, quality) let marketplace operators apply their own priorities
- **Plain text over JSON for AI responses** — Claude returns simple line-by-line 
  text, Python builds the YAML structure. Eliminates JSON parsing errors and 
  reduces output tokens by ~40%
- **Dynamic token budgeting** — input tokens counted exactly, output tokens 
  derived from prompt word constraints, actual cost tracked from API response

## Setup

**Requirements**
- Python 3.11.9
- Node.js 20+ (for Evidence.dev dashboard)
- Git
- Anthropic API key (for AI features)

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

4. Create `.env` file with your Anthropic API key
```
ANTHROPIC_API_KEY=your-key-here
```

5. Download Olist dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place all CSV files in `olist_pipeline/seeds/`

6. Create dbt profile at `C:\Users\<username>\.dbt\profiles.yml`
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

7. Load raw data and run models
```bash
cd olist_pipeline
dbt debug    # verify connection
dbt seed     # load CSV files into DuckDB
dbt run      # build all models
dbt test     # run 40 data quality tests
```

8. Run Dagster orchestration
```bash
cd ..
dagster dev -f dagster_pipeline.py
```
Open http://127.0.0.1:3000

9. Run Evidence.dev dashboard
```bash
cd evidence_dashboard
npm install
npm run sources
npm run dev
```
Open http://localhost:3000

10. Run AI seller intelligence notebook
Open `seller_competition_ai_analysis.ipynb` in VS Code or Jupyter.

11. Run AI documentation generator
Open `generate_dbt_docs.ipynb` in VS Code or Jupyter.
Regenerate descriptions for all 15 models automatically.

## Common Commands

| Command | What it does | When to use |
|---|---|---|
| `dbt debug` | Checks connection and config | First setup |
| `dbt seed` | Loads CSV files into DuckDB | First setup or CSV changes |
| `dbt run` | Builds all models | Every model change |
| `dbt test` | Runs 40 data quality tests | After building models |
| `dbt docs generate && dbt docs serve` | Opens documentation site | To view lineage |

## Status
✅ Complete