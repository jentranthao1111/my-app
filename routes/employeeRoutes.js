const express = require('express');
const db = require("../src/databasepg");
const bodyParser = require("body-parser");
const router = express.Router();

// Create employee

router.post("/employee", async(req, res) => {
    try{
        const {role, fullname, email, password, hotel_fid} = req.body;

        const newEmployee = await db.query(
            'INSERT INTO public.Employee (role, fullName, email, password, hotel_fid) VALUES ($1, $2, $3, $4, $5)',
            [role, fullname, email, password, hotel_fid]
        );
        res.json(newEmployee.rows);
    } catch (err){
        console.error(err.message);
    }
})

// Delete a employee

router.delete("/employee", async(req, res)=>{
    try{
        const employeeID = req.body.ssn_sid;

        const deleteEmployee = await db.query(
            'DELETE FROM Employee WHERE ssn_sid = $1', [employeeID]
        );
        res.json("Employee was deleted");
    } catch (err){
        console.error(err.message);
        res.status(500).json({ error: "Failed to delete Employee"});
    }
});

// Get all employee

router.get("/employee", async(req, res)=>{
    try{
        const allEmployees = await db.query("Select * from employee");
        res.json(allEmployees.rows);

    }catch(err){
        console.error(err.message);
    }
})

// validate employee

router.post("/employee/validate", async(req, res)=>{
    const { email, password } = req.body;

    try{
        const result = await db.query(
            "SELECT * FROM employee WHERE email = $1 AND password = $2",
            [email, password]
        );

         if (result.rows.length > 0) {
            //found a matching employee
      res.status(200).json({ valid: true, employeeID: result.rows[0].ssn_sid });
    } else {
      res.status(200).json({ valid: false });
    }
  } catch (err) {
    console.error("Validation error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});


// update employee full name

router.put("/employee/fullname", async(req, res)=>{
    try{
        const employeeID = req.body.ssn_sid;
        const full_name = req.body.fullname;
        const updateEmployee = await db.query("UPDATE employee SET fullname = $1 WHERE ssn_sid = $2 RETURNING *", [full_name, employeeID]);
        res.json(updateEmployee.rows);

    }catch(err){
        console.error(err.message);
    }
})

// update employee email

router.put("/employee/email", async(req, res)=>{
    try{
        const employeeID = req.body.ssn_sid;
        const email = req.body.email;
        const updateCustomer = await db.query("UPDATE employee SET email = $1 WHERE ssn_sid = $2 RETURNING *", [email, employeeID]);
        res.json(updateEmployee.rows);

    }catch(err){
        console.error(err.message);
    }
})

// get employee hotel id

router.get("/employee/hotel_fid/:ssn_sid", async (req, res) => {
    try {
      const { ssn_sid } = req.params;
  
      const result = await db.query(
        'SELECT hotel_fid FROM employee WHERE ssn_sid = $1',
        [ssn_sid]
      );
  
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, message: "Employee not found" });
      }
  
      res.json({ hotel_id: result.rows[0].hotel_fid });
    } catch (err) {
      console.error("Fetch hotel_id error:", err.message);
      res.status(500).json({ success: false, message: "Failed to fetch hotel_id" });
    }
  });
  

module.exports = router;