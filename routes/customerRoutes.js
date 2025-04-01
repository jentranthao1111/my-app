const express = require('express');
const db = require("../src/databasepg");
const bodyParser = require("body-parser");
const router = express.Router();

// Create a customer

router.post("/customer", async(req, res) => {
    try{
        const {full_name, email, password, address} = req.body;

        const newCustomer = await db.query(
            'INSERT INTO public.Customer (full_Name, email, password, address) VALUES ($1, $2, $3, $4)',
            [full_name, email, password, address]
        );
        res.json(newCustomer.rows);
    } catch (err){
        console.error(err.message);
    }
})

// Delete a customer

router.delete("/customer", async(req, res)=>{
    try{
        const customerID = req.body.cust_id;

        const deleteCustomer = await db.query(
            'DELETE FROM Customer WHERE cust_id = $1', [customerID]
        );
        res.json("Customer was deleted");
    } catch (err){
        console.error(err.message);
        res.status(500).json({ error: "Failed to delete customer"});
    }
});

// Get all customers 

router.get("/customer", async(req, res)=>{
    try{
        const allCustomers = await db.query("Select * from customer");
        res.json(allCustomers.rows);

    }catch(err){
        console.error(err.message);
    }
})

// get customer database

router.post("/customer/validate", async(req, res)=>{
    const { email, password } = req.body;

    try{
        const result = await db.query(
            "SELECT * FROM customer WHERE email = $1 AND password = $2",
            [email, password]
        );

         if (result.rows.length > 0) {
            //found a matching customer
      res.status(200).json({ valid: true, customerId: result.rows[0].cust_id });
    } else {
      res.status(200).json({ valid: false });
    }
  } catch (err) {
    console.error("Validation error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});


// update full name

router.put("/customer/full_name", async(req, res)=>{
    try{
        const cust_id = req.body.cust_id;
        const full_name = req.body.full_name;
        const updateCustomer = await db.query("UPDATE customer SET full_name = $1 WHERE customerid = $2 RETURNING *", [full_name, cust_id]);
        res.json(updateCustomers.rows);

    }catch(err){
        console.error(err.message);
    }
})

// update customer email

router.put("/customer/email", async(req, res)=>{
    try{
        const cust_id = req.body.cust_id;
        const email = req.body.email;
        const updateCustomer = await db.query("UPDATE customer SET email = $1 WHERE customerid = $2 RETURNING *", [email, cust_id]);
        res.json(updateCustomers.rows);

    }catch(err){
        console.error(err.message);
    }
})

//

module.exports = router;