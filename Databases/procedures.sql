CREATE OR REPLACE PROCEDURE newCustomer(
  INPcustomer_name VARCHAR(20),
  INPcustomer_id VARCHAR(11)
) AS $$
DECLARE
  INPamount NUMERIC := 0;
  -- (SELECT SUM(orderTable.amount) FROM orderTable WHERE orderTable.customer_id = INPcustomer_id)
BEGIN
  INSERT INTO customer(customer_name, customer_id, customer_amount) VALUES (INPcustomer_name, INPcustomer_id, INPamount);
  UPDATE customer SET customer_amount = customer.customer_amount + orderTable.amount FROM orderTable WHERE orderTable.customer_id = INPcustomer_id;
  RAISE NOTICE 'new customer created';
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE PROCEDURE newBillItem(
  INPorder_id NUMERIC,
  INPproduct_id NUMERIC
) AS $$
BEGIN
INSERT INTO bill(order_id,product_id) VALUES (INPorder_id,INPproduct_id);
END
$$
LANGUAGE
plpgsql;





CREATE OR REPLACE PROCEDURE newOrder(
  INPproduct_id NUMERIC,
  INPcustomer_id VARCHAR(11),
  INPitems NUMERIC,
  billItems NUMERIC[],
  INPcustomer_name VARCHAR(20) DEFAULT 'newCustomer'
) AS $$
DECLARE
  product_price NUMERIC DEFAULT 0;
  total_amount NUMERIC DEFAULT 0;
  customerName varchar(20) DEFAULT 'Guest';
  INPorder_id NUMERIC DEFAULT 1;
BEGIN
  SELECT order_id INTO INPorder_id from orderTable ORDER BY order_id DESC LIMIT 1;
  INPorder_id := INPorder_id + 1;
  IF INPorder_id IS NULL THEN
    INPorder_id := 1;
  END IF;

  SELECT customer_name INTO customerName from customer where customer.customer_id = INPcustomer_id;

    INSERT INTO orderTable(order_id, amount, items, customer_name, customer_id)
    VALUES (INPorder_id, total_amount, INPitems, INPcustomer_name,INPcustomer_id);
    RAISE NOTICE 'order created';
    --
  FOR i IN 1..INPitems LOOP
    INSERT INTO bill(order_id,product_id) values (INPorder_id,billItems[i]::NUMERIC);
    SELECT price INTO product_price from product where product.product_id = billItems[i]::NUMERIC;
    SELECT product_price + total_amount INTO total_amount;
  END LOOP;

  UPDATE orderTable SET amount = total_amount WHERE order_id = INPorder_id;

END
$$
LANGUAGE
plpgsql;






CREATE OR REPLACE PROCEDURE deleteOrder(
  INPorder_id NUMERIC
) AS $$
BEGIN
  DELETE FROM bill where order_id = INPorder_id;
  DELETE FROM orderTable WHERE order_id = INPorder_id;
  RAISE NOTICE 'deleted values';
END
$$
LANGUAGE
plpgsql;




CREATE OR REPLACE PROCEDURE newProduct(
  INPproduct_id NUMERIC,
  INPprice NUMERIC,
  INPproduct_name VARCHAR(20),
  INPavailability BOOLEAN,
  INPmaterial_req_id NUMERIC
) AS $$
BEGIN
  INSERT INTO product(product_id, price, product_name, availability)
    VALUES (INPproduct_id,
    INPprice,
    INPproduct_name,
    INPavailability);
    RAISE NOTICE 'product created';
  INSERT INTO mat_req(product_id,material_id) VALUES(INPproduct_id,INPmaterial_req_id);
    RAISE NOTICE 'material requirements updated';
  RAISE NOTICE 'product details updated to menu';
END
$$
LANGUAGE
plpgsql;




CREATE OR REPLACE PROCEDURE deleteProduct(
  INPproduct_id NUMERIC
) AS $$
BEGIN
  DELETE FROM mat_req where product_id = INPproduct_id;
  DELETE FROM product WHERE product_id = INPproduct_id;
  RAISE NOTICE 'deleted values from product';
END
$$
LANGUAGE
plpgsql;





CREATE OR REPLACE PROCEDURE newFeedback(
  INPcustomer_id VARCHAR(11),
  INPcustomer_name VARCHAR(20),
  INPfeedback_text VARCHAR(100)
) AS $$
BEGIN
  INSERT INTO feedback VALUES(INPcustomer_id,INPcustomer_name,INPfeedback_text);
  RAISE NOTICE 'Added Feedback';
END
$$
LANGUAGE
plpgsql;


CREATE OR REPLACE PROCEDURE dropAll() AS $$
BEGIN
  DROP TABLE customer CASCADE;
  DROP TABLE orderTable;
  DROP TABLE product;
  DROP TABLE caterer;
  DROP TABLE menu;
  DROP TABLE material;
  DROP TABLE supplier;
END;
$$
LANGUAGE
plpgsql;
















--
-- CREATE OR REPLACE PROCEDURE newOrder(
--   INPorder_id NUMERIC,
--   INPamount NUMERIC,
--   INPitems NUMERIC,
--   INPcustomer_name VARCHAR(20),
--   INPcustomer_id VARCHAR(11),
--   INPproduct_list NUMERIC
-- ) AS $$
-- BEGIN
--   INSERT INTO orderTable(order_id, amount, items, customer_name, customer_id, product_list)
--     VALUES (INPorder_id, INPamount, INPitems, INPcustomer_name, INPcustomer_id, INPproduct_list);
--     RAISE NOTICE 'order created';
--   UPDATE customer SET order_id = order_id || INPorder_id WHERE customer_id = INPcustomer_id;
--   INSERT INTO customer(customer_name, customer_id, order_id) VALUES (INPcustomer_name, INPcustomer_id, [customer.order_id,INPorder_id]);
-- --WHERE NOT EXISTS (SELECT customer_id FROM customer WHERE customer.customer_id = INPcustomer_id);
--   UPDATE customer SET customer_amount = customer_amount + INPamount WHERE customer_id = INPcustomer_id;
--   RAISE NOTICE 'order details updated to customer account';
-- END
-- $$
-- LANGUAGE
-- plpgsql;
--
--
-- CREATE OR REPLACE PROCEDURE newCustomer(
--   INPcustomer_name VARCHAR(20),
--   INPcustomer_id VARCHAR(11)
-- ) AS $$
-- DECLARE
--   INPamount NUMERIC := 0;
--   INPorder_id NUMERIC[];
-- BEGIN
--   INSERT INTO customer(customer_name, customer_id, order_id, customer_amount) VALUES (INPcustomer_name, INPcustomer_id, INPorder_id, INPamount);
--   RAISE NOTICE 'new customer created';
-- END
-- $$
-- LANGUAGE
-- plpgsql;
--
--
--
-- --
-- -- CREATE OR REPLACE PROCEDURE addNewProduct() AS $$
-- -- --
--
-- --
-- -- CREATE OR REPLACE PROCEDURE modifyProduct() AS $$
-- -- CREATE OR REPLACE PROCEDURE closeAllOrders() AS $$
--
--
-- --  The Following procudure will repalce the entire database to original status
-- CREATE OR REPLACE PROCEDURE dropAll() AS $$
-- BEGIN
--   DROP TABLE customer CASCADE;
--   DROP TABLE orderTable;
--   DROP TABLE product;
--   DROP TABLE caterer;
--   DROP TABLE menu;
--   DROP TABLE material;
--   DROP TABLE supplier;
--
-- END;
-- $$
-- LANGUAGE
-- plpgsql;
--
--
--
-- CREATE OR REPLACE PROCEDURE resetAll() AS $$
-- BEGIN
--   DROP TABLE customer;
--   DROP TABLE orderTable;
--   DROP TABLE product;
--   DROP TABLE caterer;
--
--   CREATE TABLE IF NOT EXISTS customer(
--     customer_id VARCHAR(11) NOT NULL UNIQUE PRIMARY KEY,
--     customer_amount NUMERIC,
--     customer_name VARCHAR(20),
--     order_id NUMERIC[] NOT NULL
--   );
--
--
--   CREATE TABLE IF NOT EXISTS orderTable(
--     order_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
--     amount NUMERIC,
--     items NUMERIC,
--     customer_name VARCHAR(20),
--     customer_id VARCHAR(11) NOT NULL,
--     product_list NUMERIC[],
--     processed BOOLEAN,
--     FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
--   );
--
--
--
--   CREATE TABLE IF NOT EXISTS product(
--     product_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
--     price NUMERIC,
--     product_name VARCHAR(20) NOT NULL,
--     availability BOOLEAN
--   );
--
--
--   CREATE TABLE IF NOT EXISTS caterer(
--       order_list NUMERIC[],
--       product_list NUMERIC[]
--   );
--
--   CREATE TABLE IF NOT EXISTS menu(
--     product_list NUMERIC[],
--     product_price NUMERIC[]
--     --FOREIGN KEY (EACH ELEMENT OF product_list) REFERENCES product(product_id),
--   --  FOREIGN KEY (EACH ELEMENT OF product_price) REFERENCES product(price)
--   );
--
--
--
--
--   CREATE TABLE IF NOT EXISTS  material(
--     material_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
--     price NUMERIC,
--     material_name VARCHAR(20),
--     material_desc VARCHAR(50)
--   );
--
--
--   CREATE TABLE IF NOT EXISTS supplier(
--     supplier_id NUMERIC NOT NULL,
--     product_supplied VARCHAR(20) NOT NULL,
--     PRIMARY KEY(supplier_id, product_supplied)
--   );
--
-- END;
-- $$
-- LANGUAGE
-- plpgsql;
