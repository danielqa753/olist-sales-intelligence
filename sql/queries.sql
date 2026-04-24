-- ══════════════════════════════════════════════════════
-- OLIST SALES INTELLIGENCE — Analytical Queries
-- ══════════════════════════════════════════════════════

-- ── 1. Revenue total y promedio por año ──────────────
-- Pregunta: ¿Cómo creció el negocio año a año?
-- Question: How did the business grow year over year?
SELECT
    order_year,
    SUM(total_orders)             AS total_orders,
    ROUND(SUM(gross_revenue), 2)  AS total_revenue,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value
FROM vw_monthly_revenue
GROUP BY order_year
ORDER BY order_year;

-- ── 2. Top 10 categorias por revenue ─────────────────
-- Pregunta: ¿Qué categorías generan más dinero?
-- Question: Which product categories generate the most revenue?
SELECT
    category_english,
    total_orders,
    gross_revenue,
    avg_price,
    avg_review_score
FROM vw_revenue_by_category
LIMIT 10;

-- ── 3. Top 10 estados por revenue ────────────────────
-- Pregunta: ¿Qué regiones concentran las ventas?
-- Question: Which regions concentrate the most sales?
SELECT
    customer_state,
    total_orders,
    gross_revenue,
    avg_delivery_days,
    late_delivery_pct
FROM vw_revenue_by_state
LIMIT 10;

-- ── 4. Estados con mayor tasa de entrega tardía ──────
-- Pregunta: ¿Dónde falla la logística?
-- Question: Which states have the worst delivery performance?
SELECT
    customer_state,
    total_orders,
    avg_delivery_days,
    late_delivery_pct
FROM vw_revenue_by_state
WHERE total_orders > 100
ORDER BY late_delivery_pct DESC
LIMIT 10;

-- ── 5. Distribución de métodos de pago ───────────────
-- Pregunta: ¿Cómo pagan los clientes?
-- Question: What payment methods do customers prefer?
SELECT
    payment_type,
    total_orders,
    gross_revenue,
    avg_installments
FROM vw_payment_analysis;

-- ── 6. Impacto de entregas tardías en review score ───
-- Pregunta: ¿Las entregas tardías afectan la satisfacción?
-- Question: Do late deliveries negatively impact customer satisfaction?
SELECT
    review_score,
    total_orders,
    avg_delivery_days,
    late_delivery_pct
FROM vw_review_vs_delivery;

-- ── 7. Mejor y peor mes por revenue ──────────────────
-- Pregunta: ¿Hay estacionalidad en las ventas?
-- Question: Is there seasonality in sales performance?
SELECT
    TO_CHAR(order_month, 'YYYY-MM') AS month,
    total_orders,
    gross_revenue
FROM vw_monthly_revenue
ORDER BY gross_revenue DESC
LIMIT 5;

-- ── 8. Categorias con mejor review score ─────────────
-- Pregunta: ¿Qué categorías tienen clientes más satisfechos?
-- Question: Which product categories have the most satisfied customers?
SELECT
    category_english,
    total_orders,
    avg_review_score,
    gross_revenue
FROM vw_revenue_by_category
WHERE total_orders > 200
ORDER BY avg_review_score DESC
LIMIT 10;