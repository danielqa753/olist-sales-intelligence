-- ══════════════════════════════════════════════════════
-- OLIST SALES INTELLIGENCE — Business Views
-- ══════════════════════════════════════════════════════

-- ── 1. Vista principal de ventas ─────────────────────
CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    DATE_TRUNC('month', o.order_purchase_timestamp)  AS order_month,
    EXTRACT(YEAR FROM o.order_purchase_timestamp)    AS order_year,
    o.delivery_days,
    o.is_late_delivery,
    c.customer_state,
    c.customer_city,
    p.category_english,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value)                    AS total_value,
    pay.payment_type,
    pay.payment_installments,
    r.review_score,
    s.seller_state
FROM orders o
LEFT JOIN order_items    oi  ON o.order_id = oi.order_id
LEFT JOIN customers      c   ON o.customer_id = c.customer_id
LEFT JOIN products       p   ON oi.product_id = p.product_id
LEFT JOIN order_payments pay ON o.order_id = pay.order_id
LEFT JOIN order_reviews  r   ON o.order_id = r.order_id
LEFT JOIN sellers        s   ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered';

-- ── 2. Revenue mensual ───────────────────────────────
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    order_month,
    order_year,
    COUNT(DISTINCT order_id)     AS total_orders,
    ROUND(SUM(price)::NUMERIC, 2) AS gross_revenue,
    ROUND(AVG(price)::NUMERIC, 2) AS avg_order_value
FROM vw_sales_summary
GROUP BY order_month, order_year
ORDER BY order_month;

-- ── 3. Revenue por categoria ─────────────────────────
CREATE OR REPLACE VIEW vw_revenue_by_category AS
SELECT
    category_english,
    COUNT(DISTINCT order_id)      AS total_orders,
    ROUND(SUM(price)::NUMERIC, 2) AS gross_revenue,
    ROUND(AVG(price)::NUMERIC, 2) AS avg_price,
    ROUND(AVG(review_score)::NUMERIC, 2) AS avg_review_score
FROM vw_sales_summary
WHERE category_english IS NOT NULL
GROUP BY category_english
ORDER BY gross_revenue DESC;

-- ── 4. Performance por estado ────────────────────────
CREATE OR REPLACE VIEW vw_revenue_by_state AS
SELECT
    customer_state,
    COUNT(DISTINCT order_id)      AS total_orders,
    ROUND(SUM(price)::NUMERIC, 2) AS gross_revenue,
    ROUND(AVG(delivery_days)::NUMERIC, 1) AS avg_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END)
        / NULLIF(COUNT(delivery_days), 0), 1
    ) AS late_delivery_pct
FROM vw_sales_summary
WHERE delivery_days IS NOT NULL
GROUP BY customer_state
ORDER BY gross_revenue DESC;

-- ── 5. Performance por metodo de pago ────────────────
CREATE OR REPLACE VIEW vw_payment_analysis AS
SELECT
    payment_type,
    COUNT(DISTINCT order_id)      AS total_orders,
    ROUND(SUM(price)::NUMERIC, 2) AS gross_revenue,
    ROUND(AVG(payment_installments)::NUMERIC, 1) AS avg_installments
FROM vw_sales_summary
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY total_orders DESC;

-- ── 6. Review score vs delivery ──────────────────────
CREATE OR REPLACE VIEW vw_review_vs_delivery AS
SELECT
    review_score,
    COUNT(DISTINCT order_id)    AS total_orders,
    ROUND(AVG(delivery_days)::NUMERIC, 1) AS avg_delivery_days,
    ROUND(
        100.0 * SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END)
        / NULLIF(COUNT(delivery_days), 0), 1
    ) AS late_delivery_pct
FROM vw_sales_summary
WHERE review_score IS NOT NULL
  AND delivery_days IS NOT NULL
GROUP BY review_score
ORDER BY review_score DESC;