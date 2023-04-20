
CREATE TABLE IF NOT EXISTS customer(
  customer_id VARCHAR(11) NOT NULL UNIQUE PRIMARY KEY,
  customer_amount NUMERIC,
  customer_name VARCHAR(20) NOT NULL
);



CREATE TABLE IF NOT EXISTS product(
  product_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
  price NUMERIC NOT NULL,
  product_name VARCHAR(20) NOT NULL,
  availability BOOLEAN,
  product_cost NUMERIC
);

CREATE TABLE IF NOT EXISTS orderTable(
  order_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
  amount NUMERIC,
  items NUMERIC,
  customer_name VARCHAR(20),
  customer_id VARCHAR(11) NOT NULL,
  processed BOOLEAN DEFAULT FALSE,
  order_date DATE DEFAULT CURRENT_DATE,
  payment_method VARCHAR(10),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- bridge entity for product and ordertable
CREATE TABLE IF NOT EXISTS bill(
  order_id NUMERIC NOT NULL,
  product_id NUMERIC NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orderTable(order_id),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);



CREATE TABLE IF NOT EXISTS caterer(
    total_earning NUMERIC,
    total_cost NUMERIC,
    total_sale NUMERIC,
    total_product_count NUMERIC,
    total_material_cost NUMERIC
);



CREATE TABLE IF NOT EXISTS supplier(
  supplier_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
  supplier_name VARCHAR(20),
  supplier_item VARCHAR(20),
  supplier_amount NUMERIC,
  supplier_order_count NUMERIC
);


CREATE TABLE IF NOT EXISTS material(
  material_id NUMERIC NOT NULL UNIQUE PRIMARY KEY,
  price NUMERIC,
  material_name VARCHAR(20),
  material_desc VARCHAR(50),
  supplier_id NUMERIC,
  FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- brdige entity between prodcut and material
CREATE TABLE IF NOT EXISTS mat_req(
  product_id NUMERIC NOT NULL,
  material_id NUMERIC NOT NULL,
  FOREIGN KEY (product_id) REFERENCES product(product_id),
  FOREIGN KEY (material_id) REFERENCES material(material_id)
);

CREATE TABLE IF NOT EXISTS feedback(
  customer_id VARCHAR(11),
  customer_name VARCHAR(20),
  feedback_text VARCHAR(100)
);
