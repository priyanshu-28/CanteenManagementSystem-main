CREATE OR REPLACE TRIGGER customer_update BEFORE INSERT on orderTable
FOR EACH ROW
  EXECUTE FUNCTION update_customer();



CREATE OR REPLACE FUNCTION update_customer() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO customer SELECT NEW.customer_id, NEW.amount, NEW.customer_name WHERE NOT EXISTS(select customer_id from customer where customer_id= NEW.customer_id);
  RAISE NOTICE 'Trigger Called: Customer Values Updated';
  RETURN NEW;
END
$$
LANGUAGE
plpgsql;





CREATE OR REPLACE TRIGGER earning_update AFTER INSERT on orderTable
FOR EACH ROW
  EXECUTE FUNCTION update_earning();



CREATE OR REPLACE FUNCTION update_earning() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO caterer(total_earning) (SELECT SUM(orderTable.amount) FROM orderTable WHERE processed = TRUE);
  RAISE NOTICE 'Total Earning updated';
  RETURN NEW;
END
$$
LANGUAGE
plpgsql;



CREATE OR REPLACE TRIGGER beforeDelete BEFORE DELETE ON orderTable
FOR EACH ROW
EXECUTE FUNCTION check_processed();


CREATE OR REPLACE FUNCTION check_processed() RETURNS TRIGGER AS $$
DECLARE
  -- orderProcessed BOOLEAN := SELECT processed from orderTable WHERE OLD.order_id = orderTable.order_id;
BEGIN
  IF((SELECT processed from orderTable WHERE OLD.order_id = orderTable.order_id) = TRUE) THEN
    RAISE EXCEPTION 'Sorry The order has been processed';
    RETURN NULL;
  END IF;
  RETURN NEW;

END;
$$
LANGUAGE
plpgsql;




CREATE OR REPLACE TRIGGER product_update BEFORE INSERT ON product
FOR EACH ROW
EXECUTE FUNCTION check_product();




CREATE OR REPLACE FUNCTION check_product() RETURNS TRIGGER AS $$

  -- orderProcessed BOOLEAN := SELECT processed from orderTable WHERE OLD.order_id = orderTable.order_id;
BEGIN
  IF NOT EXISTS (SELECT product_name from product WHERE NEW.product_name = product.product_name) THEN
    RETURN NEW;
  END IF;
  RAISE EXCEPTION 'SORRY, PRODUCT ALREADY EXISTS';
  RAISE NOTICE 'Sorry , product already exists , insert different product';
  RETURN OLD;
END;
$$
LANGUAGE
plpgsql;




CREATE OR REPLACE TRIGGER id_check BEFORE INSERT ON customer
FOR EACH ROW
EXECUTE FUNCTION check_customer_id();




CREATE OR REPLACE FUNCTION check_customer_id() RETURNS TRIGGER AS $$

  -- orderProcessed BOOLEAN := SELECT processed from orderTable WHERE OLD.order_id = orderTable.order_id;
BEGIN
  IF (SELECT substring(NEW.customer_id from 1 for 2) = 'AU') THEN
    RETURN NEW;
  END IF;
  RAISE EXCEPTION 'Please add initial values';
  RAISE NOTICE 'Initial AU could be missing';
  RETURN OLD;
END;
$$
LANGUAGE
plpgsql;
