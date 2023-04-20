--
CREATE OR REPLACE FUNCTION getPendingOrder() RETURNS TABLE(order_id NUMERIC, customer_name VARCHAR(20), customer_id VARCHAR(11), amount NUMERIC) AS $$
BEGIN
  RETURN QUERY SELECT orderTable.order_id, orderTable.customer_name, orderTable.customer_id, orderTable.amount FROM orderTable WHERE (orderTable.processed = false);
END
$$
LANGUAGE
plpgsql;
--
--
--
CREATE OR REPLACE FUNCTION filterTableElements(cutoffLimit NUMERIC) RETURNS TABLE(
  customer_id VARCHAR(11),
  order_id NUMERIC,
  amount NUMERIC,
  order_date DATE
) AS $$
BEGIN
  RETURN QUERY SELECT
  customer.customer_id,
  orderTable.order_id,
  orderTable.amount,
  orderTable.order_date
   FROM
    ordertable FULL OUTER JOIN customer ON ordertable.customer_id = customer.customer_id
    WHERE customer.customer_amount > cutoffLimit OR ordertable.amount > cutoffLimit;
END;
$$
LANGUAGE
plpgsql;



--
CREATE OR REPLACE FUNCTION getMaxPayingCustomer() RETURNS RECORD AS $$
BEGIN
  RETURN (SELECT (customer_name,customer_id) FROM customer WHERE customer_amount = (SELECT MAX(customer_amount) FROM customer) LIMIT 1);
END
$$
LANGUAGE
plpgsql;



CREATE OR REPLACE FUNCTION getMaxOrder() RETURNS RECORD AS $$
BEGIN
  RETURN (SELECT (order_id, customer_name) FROM orderTable WHERE amount = (SELECT MAX(amount) FROM orderTable));
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE FUNCTION getMenu() RETURNS TABLE(product_name VARCHAR(20), price NUMERIC) AS $$
BEGIN
  RETURN QUERY (SELECT product.product_name, product.price FROM product WHERE product.availability = TRUE);
END
$$
LANGUAGE
plpgsql;




CREATE OR REPLACE FUNCTION getTotalSale() RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT SUM(amount) FROM orderTable WHERE processed = true);
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE FUNCTION getTotalOrders() RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM orderTable WHERE processed = true);
END
$$
LANGUAGE
plpgsql;



CREATE OR REPLACE FUNCTION getCustomerCount() RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM customer);
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE FUNCTION getMaterialCost() RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT SUM(price) FROM material);
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE FUNCTION getCustomerDetails(inpCustomerId VARCHAR(11)) RETURNS
TABLE(
  customer_id VARCHAR(11),
  customer_name VARCHAR(20),
  amount NUMERIC,
  order_id NUMERIC,
  items NUMERIC
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      customer.customer_id,
      customer.customer_name,
      orderTable.amount,
      orderTable.order_id,
      orderTable.items

    FROM
      customer INNER JOIN orderTable on customer.customer_id = orderTable.customer_id
    WHERE customer.customer_id = inpCustomerId;
END
$$
LANGUAGE
plpgsql;
