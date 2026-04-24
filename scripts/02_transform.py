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

# ── Transformaciones ─────────────────────────────────────
def transform():
    with engine.connect() as conn:

        print("1. Convirtiendo fechas en orders...")
        conn.execute(text("""
            ALTER TABLE orders
                ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP
                    USING order_purchase_timestamp::TIMESTAMP,
                ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP
                    USING order_delivered_customer_date::TIMESTAMP,
                ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP
                    USING order_estimated_delivery_date::TIMESTAMP;
        """))
        conn.commit()
        print("  ✓ Fechas convertidas")

        print("2. Agregando columna delivery_days...")
        conn.execute(text("""
            ALTER TABLE orders
                ADD COLUMN IF NOT EXISTS delivery_days INTEGER;

            UPDATE orders
            SET delivery_days = EXTRACT(
                DAY FROM (
                    order_delivered_customer_date - order_purchase_timestamp
                )
            )
            WHERE order_delivered_customer_date IS NOT NULL;
        """))
        conn.commit()
        print("  ✓ delivery_days calculado")

        print("3. Agregando columna is_late_delivery...")
        conn.execute(text("""
            ALTER TABLE orders
                ADD COLUMN IF NOT EXISTS is_late_delivery BOOLEAN;

            UPDATE orders
            SET is_late_delivery = (
                order_delivered_customer_date > order_estimated_delivery_date
            )
            WHERE order_delivered_customer_date IS NOT NULL
              AND order_estimated_delivery_date IS NOT NULL;
        """))
        conn.commit()
        print("  ✓ is_late_delivery calculado")

        print("4. Traduciendo categorias de productos...")
        conn.execute(text("""
            ALTER TABLE products
                ADD COLUMN IF NOT EXISTS category_english TEXT;

            UPDATE products p
            SET category_english = ct.product_category_name_english
            FROM category_translation ct
            WHERE p.product_category_name = ct.product_category_name;
        """))
        conn.commit()
        print("  ✓ Categorias traducidas")

    print("\nTransformaciones completadas.")

if __name__ == "__main__":
    transform()