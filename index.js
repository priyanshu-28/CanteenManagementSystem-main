const express = require("express");
const app = express();
const pool = require("./db");
const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.set("view engine", "ejs");

const logData = (query, output) => {
  console.log("~~~~Query/ Function~~~~");
  console.log(query, "\n");
  console.log("~~~~Output~~~~");
  console.log(output, "\n", "\n");
};

const errorProduced = "";

app.get("/", async (req, res) => {
  try {
    const productData = await pool.query("SELECT * FROM product;");
    logData("SELECT * FROM product;", productData.rows);
    res.render("homepage", { productList: productData.rows , error:"Sorry Some Error has occured"});
  } catch (err) {
    console.log(err);
  }
});

app.get("/product", async (req, res) => {
  try {
    const newOrder = await pool.query("SELECT * FROM product;");
    res.send(newOrder);
  } catch (err) {
    console.log(err);
  }
});

app.get("/caterer", async (req, res) => {
  try {
    const productList = await pool.query("SELECT * FROM product;");
    logData("SELECT * FROM product;", productList.rows);
    const orderList = await pool.query("SELECT * FROM orderTable;");
    logData("SELECT * FROM orderTable;", orderList);
    res.render("caterer", {
      productList: productList.rows,
      orderList: orderList.rows,
      error: errorProduced
    });
  } catch (err) {
    console.log(err);
  }
});




// get product list
app.get("/caterer/product", async (req, res) => {
  try {
    const newOrder = await pool.query("SELECT * FROM product;");
    logData("SELECT * FROM product;", newOrder.rows);
    res.render(caterer);
  } catch (err) {
    console.log(err);
  }
});
//
app.post("/caterer/product/new", async (req, res) => {
  try {
    const orderData = req.body;

    // const newOrder = await pool.query(
    //   "INSERT INTO product (product_id, product_name, availability, price) VALUES ($1, $2, $3, $4);",
    //   [
    //     orderData.product_id,
    //     orderData.product_name,
    //     orderData.availability,
    //     orderData.price,
    //   ]
    // );

    const newProduct = await pool.query(
      "CALL newProduct($1, $2, $3, $4,$5);",
        [
          parseInt(orderData.product_id),
          parseInt(orderData.price),
          String(orderData.product_name),
          Boolean(orderData.availability),
          parseInt(orderData.mat_req_id)
        ]
    )
    logData("CALL newProduct($1, $2, $3, $4)", newProduct);
    res.redirect("/caterer");
  } catch (err) {
    console.log(err);
  }
});
//delete the product
app.post("/caterer/product/delete", async (req, res) => {
  try {
    const productData = req.body;
    const queryResult = await pool.query(
      "call deleteProduct($1);",
      [parseInt(productData.product_id)]
    );
    res.redirect("/caterer");
  } catch (err) {
    console.log(err);
  }
});


// get pending order
app.get("/caterer/pendingOrder", async (req, res) => {
  try {
    const orderData = await pool.query("SELECT getPendingOrder();");
    res.redirect("/caterer");
    console.log(orderData);
  } catch (err) {
    console.log(err);
  }
});

app.get("/analytics", async (req, res) => {
  try {
    const totalSale = await pool.query("SELECT getTotalSale();");
    const totalOrders = await pool.query("SELECT getTotalOrders();");
    const customerCount = await pool.query("SELECT getCustomerCount();");
    const materialCost = await pool.query("SELECT getMaterialCost();");
    const maxPayingCustomer = await pool.query("SELECT getMaxPayingCustomer();");
    const pendingOrder = await pool.query("SELECT getPendingOrder();")
    const feedbackList = await pool.query("SELECT * from feedback;")
    const pendingOrderCount = pendingOrder.rows.length;
    // logData("SELECT getTotalSale();",totalSale.rows);
    // logData("SELECT getTotalOrders();",totalOrders.rows);
    // logData("SELECT getCustomerCount();",customerCount.rows);
    // logData("SELECT getMaterialCost();",materialCost.rows);
    // logData("SELECT getMaxPayingCustomer();", maxPayingCustomer.rows);
    // logData("SELECT getPendingOrder();", pendingOrder.rows);
    res.render("analytics",
    {
      totalSale: totalSale.rows[0].gettotalsale,
      totalOrders: totalOrders.rows[0].gettotalorders,
      customerCount: customerCount.rows[0].getcustomercount,
      materialCost: materialCost.rows[0].getmaterialcost,
      maxPayingCustomer: maxPayingCustomer.rows[0].getmaxpayingcustomer,
      feedback: feedbackList.rows,
      error:"Sorry some error!"
     });
  } catch (err) {
    console.log(err);
    res.redirect("/");
  }
});



app.get("/customer", async (req, res) => {

  try {
    const customerData = await pool.query("SELECT * from customer;")
    res.render("customer",{customerList: customerData.rows, customerSelected: false, customerData: [], error: 'Please add initial values'});
  } catch (err) {
    console.log(err);
    res.redirect("/");
  }
});


app.post("/customer/new", async (req, res) => {
  const formData = req.body;
  try {
    const customerData = await pool.query("CALL newCustomer($1,$2)", [formData.customerName,formData.customerId])
    logData("CALL newCustomer($1,$2), [formData.customerName,formData.customerId]",customerData.rows)
    res.redirect("/customer");
  } catch (err) {
    console.log(err);
    res.redirect("/customer");
  }
});

app.post("/customer/getDetails" ,async (req, res) => {
  const customer_id = req.body.customer_id;
  try {
    const customerData = await pool.query("SELECT getCustomerDetails($1)",[customer_id]);
    console.log(customerData);
    const allCustomerData = await pool.query("SELECT * from customer;")
    logData("SELECT getCustomerDetails($1)", customerData.rows)
    res.render("customer",{customerList: allCustomerData.rows, customerSelected: true,  customerData: customerData.rows, error: 'Please add initial values'});
  } catch (err) {
    console.log(err);
    res.redirect("/");
  }
});


app.post("/order/new", async (req, res) => {
  try {
    const orderData = req.body;
     console.log(String(orderData.product_list).split(',').map(Number));
    const resultData = await pool.query(
      "CALL newOrder($1,$2,$3,$4,$5);", [
        parseInt(orderData.product_id),
        String(orderData.customer_id),
        parseInt(orderData.quantity),
        String(orderData.product_list).split(',').map(Number),
        // JSON.parse("[" + JSON.stringify(orderData.product_list) + "]"),
        String(orderData.customer_name)
      ]
    )
    // logData("CALL newOrder( customer_id, product_id, items, customer_NAME) VALUES ($1,$2,$3);", [
    //   int(orderData.product_id),
    //   String(orderData.customer_id),
    //   int(orderData.quantity),
    //   String(orderData.customer_name)
    // ]);
    res.redirect("/");
  } catch (err) {
    console.log(err);
  }
});






app.post("/order/cancel", async (req, res) => {
  try {
    const orderData = req.body;
    console.log(orderData);
    const queryResult = await pool.query(
      "call deleteOrder($1);",
      [parseInt(orderData.order_id)]
    );
    console.log("done");
    res.redirect("/");
  } catch (err) {
    console.log(err);
  }
});



app.post("/caterer/order/update", async (req, res) => {
  try {
    const orderData = req.body;
    console.log(orderData);
    const queryResult = await pool.query(
      "UPDATE orderTable SET processed = TRUE WHERE order_id = $1",
      [parseInt(orderData.updateOrder_id)]
    );
    console.log("done");
    res.redirect("/caterer");
  } catch (err) {
    console.log(err);
  }
});


app.post("/feedback/new", async (req, res) => {
  try {
    const orderData = req.body;
    console.log(orderData);
    const queryResult = await pool.query(
      "call newFeedback($1,$2,$3)",
      [String(orderData.customer_id),String(orderData.customer_name),String(orderData.feedback_desc)]
    );
    console.log("done");
    res.redirect("/");
  } catch (err) {
    console.log(err);
  }
});
app.listen(5000, () => {
  console.log("server Running");
});
