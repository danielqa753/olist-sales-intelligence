-- ══════════════════════════════════════════════════════
-- OLIST SALES INTELLIGENCE — Schema Documentation
-- ══════════════════════════════════════════════════════

-- Este archivo documenta la estructura de las tablas
-- cargadas via 01_ingest.py y transformadas via 02_transform.py

-- orders: tabla principal de pedidos
--   order_id                    PK
--   customer_id                 FK → customers
--   order_status                delivered | shipped | canceled | ...
--   order_purchase_timestamp    TIMESTAMP
--   order_delivered_customer_date TIMESTAMP
--   order_estimated_delivery_date TIMESTAMP
--   delivery_days               INTEGER (calculado en transform)
--   is_late_delivery            BOOLEAN (calculado en transform)

-- order_items: items por pedido
--   order_id                    FK → orders
--   product_id                  FK → products
--   seller_id                   FK → sellers
--   price                       NUMERIC
--   freight_value               NUMERIC

-- order_payments: pagos por pedido
--   order_id                    FK → orders
--   payment_type                credit_card | boleto | voucher | debit_card
--   payment_installments        INTEGER
--   payment_value               NUMERIC

-- customers: clientes
--   customer_id                 PK
--   customer_city               TEXT
--   customer_state              TEXT (2-letter BR state code)

-- products: catalogo de productos
--   product_id                  PK
--   product_category_name       TEXT (portugues)
--   category_english            TEXT (traducido en transform)

-- sellers: vendedores
--   seller_id                   PK
--   seller_city                 TEXT
--   seller_state                TEXT

-- order_reviews: reviews de clientes
--   review_id                   PK
--   order_id                    FK → orders
--   review_score                INTEGER 1-5

-- geolocation: coordenadas por zip code
--   geolocation_zip_code_prefix TEXT
--   geolocation_lat             NUMERIC
--   geolocation_lng             NUMERIC
--   geolocation_city            TEXT
--   geolocation_state           TEXT