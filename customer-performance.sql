
WITH customer_report AS
(SELECT c.customer_id, c.customer_name, c.country, c.city,
COUNT(DISTINCT o.order_id) total_order, MIN(o.order_date) first_order, MAX(o.order_date)
last_date FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.country, c.city), order_analysis AS
(SELECT o.customer_id, COUNT(od.quantity) total_items, 
SUM(od.quantity * p.price) total_revenue
 FROM orders o JOIN order_detail od ON o.order_id = od.order_id 
 JOIN products p ON od.product_id = p.product_id GROUP BY o.customer_id)
 SELECT cr.customer_name, cr.customer_name, cr.country, cr.city, cr.total_order, 
 COALESCE(oa.total_items, 0) total_items, COALESCE(oa.toal_revenue,0) total_revenue,
 ROUND(COALESCE(oa.total_items,0) / NULLIF(cr.total_order, 0), 2) average_order_value 
 FROM customer_report cr LEFT JOIN order_analysis oa ON cr.customer_id = oa.customer_id 
 ORDER BY total_revenue DESC;
