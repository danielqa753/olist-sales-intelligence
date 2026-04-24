# 🛒 Olist Sales Intelligence

End-to-end BI project analyzing 100K+ e-commerce orders from Olist,
Brazil's largest online marketplace. Built to demonstrate a full
analytics pipeline: raw data ingestion, SQL transformation, and
an executive Power BI dashboard.

---

## 🎯 Business Problem

A regional e-commerce platform needs to understand sales performance
across geographies, product categories, and payment methods — so the
commercial team can make data-driven expansion and logistics decisions.

---

## 🔍 Key Findings

| Insight | Detail |
|---|---|
| 📈 17x revenue growth | Business scaled from $42K (2016) to $6.3M (2017) |
| 🏆 Top category | Health & Beauty — $1.27M gross revenue |
| 🗺️ Regional concentration | São Paulo represents 38% of all orders |
| 🚚 Logistics gap | Alagoas (AL) has 24.5% late delivery rate vs 5.7% in SP |
| ⭐ Satisfaction driver | Orders with review score 1 have 31.7% late deliveries vs 3.0% for score 5 |

---

## 🏗️ Architecture

CSV Raw Data (Kaggle)
↓
Python scripts (ingestion + transformation + validation)
↓
PostgreSQL (schema + business views)
↓
Power BI Dashboard (connected to PostgreSQL)

---

## 📁 Repository Structure

olist-sales-intelligence/
├── data/raw/              ← Raw CSV files (not tracked in git)
├── scripts/
│   ├── 01_ingest.py       ← Load CSVs into PostgreSQL
│   ├── 02_transform.py    ← Type casting, derived columns
│   └── 03_validate.py     ← Row counts, null checks, stats
├── sql/
│   ├── schema.sql         ← Table documentation
│   ├── views.sql          ← 6 business views
│   └── queries.sql        ← 8 analytical queries with findings
├── dashboard/
│   ├── screenshots/       ← Dashboard visuals
│   └── sales_report.pdf   ← Exported dashboard
└── docs/
└── architecture.png   ← Pipeline diagram

---

## 🛠️ Tech Stack

- **Python** — pandas, sqlalchemy, psycopg2
- **PostgreSQL 18** — data warehouse, views, analytical queries
- **Power BI** — executive dashboard with 6 KPI pages

---

## 📊 Dashboard Pages

1. **Executive Summary** — Revenue KPIs, YoY growth
2. **Category Performance** — Top 10 categories by revenue and review score
3. **Regional Analysis** — State-level revenue and delivery heatmap
4. **Logistics Performance** — Late delivery rates by state
5. **Payment Methods** — Distribution and installment behavior
6. **Customer Satisfaction** — Review score vs delivery correlation

---

## ▶️ How to Run

**Requirements:** Python 3.8+, PostgreSQL 18, Power BI Desktop

```bash
# 1. Install dependencies
pip install pandas sqlalchemy psycopg2-binary

# 2. Place raw CSVs in data/raw/

# 3. Update DB credentials in each script

# 4. Run pipeline
python scripts/01_ingest.py
python scripts/02_transform.py
python scripts/03_validate.py

# 5. Create views
psql -U postgres -d olist_sales -f sql/views.sql

# 6. Open dashboard/olist_sales.pbix in Power BI Desktop
```

---

## 👤 Author

**Daniel Quiñones** — Data Analyst | BI & Analytics Engineer
[LinkedIn](https://www.linkedin.com/in/rommel-daniel-quinones-arteaga/) · [GitHub](https://github.com/danielqa753)
