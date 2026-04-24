import pandas as pd
from sqlalchemy import create_engine
import os

# ── Config ──────────────────────────────────────────────
DB_USER     = "postgres"
DB_PASSWORD = "46353783"  # cambia esto
DB_HOST     = "localhost"
DB_PORT     = "5432"
DB_NAME     = "olist_sales"

RAW_DATA_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "raw")

# ── Conexión ─────────────────────────────────────────────
engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# ── Archivos a cargar ────────────────────────────────────
files = {
    "orders":        "olist_orders_dataset.csv",
    "order_items":   "olist_order_items_dataset.csv",
    "order_payments":"olist_order_payments_dataset.csv",
    "customers":     "olist_customers_dataset.csv",
    "products":      "olist_products_dataset.csv",
    "sellers":       "olist_sellers_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "geolocation":   "olist_geolocation_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}

# ── Ingesta ──────────────────────────────────────────────
def ingest():
    for table_name, filename in files.items():
        filepath = os.path.join(RAW_DATA_PATH, filename)
        print(f"Loading {filename}...")
        df = pd.read_csv(filepath)
        df.to_sql(
            name=table_name,
            con=engine,
            if_exists="replace",
            index=False
        )
        print(f"  ✓ {len(df):,} rows → table '{table_name}'")
    print("\nIngesta completada.")

if __name__ == "__main__":
    ingest()