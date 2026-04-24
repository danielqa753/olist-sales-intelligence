import pandas as pd
from sqlalchemy import create_engine, text

# ── Config ───────────────────────────────────────────────
DB_USER     = "postgres"
DB_PASSWORD = "46353783"  # cambia esto
DB_HOST     = "localhost"
DB_PORT     = "5432"
DB_NAME     = "olist_sales"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# ── Validaciones ─────────────────────────────────────────
def validate():
    with engine.connect() as conn:

        print("=== ROW COUNTS ===")
        tables = [
            "orders", "order_items", "order_payments",
            "customers", "products", "sellers",
            "order_reviews", "geolocation", "category_translation"
        ]
        for table in tables:
            result = conn.execute(text(f"SELECT COUNT(*) FROM {table}"))
            count = result.scalar()
            print(f"  {table:<25} {count:>10,} rows")

        print("\n=== NULLS EN COLUMNAS CLAVE ===")
        checks = {
            "orders":        ["order_id", "customer_id", "order_status"],
            "order_items":   ["order_id", "product_id", "price"],
            "order_payments":["order_id", "payment_value"],
            "customers":     ["customer_id", "customer_state"],
        }
        for table, columns in checks.items():
            for col in columns:
                result = conn.execute(text(
                    f"SELECT COUNT(*) FROM {table} WHERE {col} IS NULL"
                ))
                nulls = result.scalar()
                status = "✓" if nulls == 0 else "⚠️ "
                print(f"  {status} {table}.{col:<30} {nulls:>6} nulls")

        print("\n=== ORDER STATUS DISTRIBUTION ===")
        result = conn.execute(text("""
            SELECT order_status, COUNT(*) as total
            FROM orders
            GROUP BY order_status
            ORDER BY total DESC
        """))
        for row in result:
            print(f"  {row[0]:<20} {row[1]:>8,}")

        print("\n=== DELIVERY STATS ===")
        result = conn.execute(text("""
            SELECT
                ROUND(AVG(delivery_days), 1)        AS avg_delivery_days,
                MIN(delivery_days)                   AS min_delivery_days,
                MAX(delivery_days)                   AS max_delivery_days,
                SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END) AS late_deliveries,
                COUNT(delivery_days)                 AS total_delivered
            FROM orders
            WHERE delivery_days IS NOT NULL
        """))
        row = result.fetchone()
        print(f"  Avg delivery days : {row[0]}")
        print(f"  Min delivery days : {row[1]}")
        print(f"  Max delivery days : {row[2]}")
        print(f"  Late deliveries   : {row[3]:,} of {row[4]:,}")

    print("\nValidacion completada.")

if __name__ == "__main__":
    validate()