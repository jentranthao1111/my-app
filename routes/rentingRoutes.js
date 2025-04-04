const express = require('express');
const db = require("../src/databasepg");
const router = express.Router();

// Create a renting
router.post("/renting", async (req, res) => {
    try {
      const { startdate, enddate, status, payment, employ_sid, cust_id, room_id, hotel_id } = req.body;
  
      const newRenting = await db.query(
        `INSERT INTO public.renting ( "startdate", "enddate", "status", "payment", "employ_sid", "cust_id", "room_id", "hotel_id") VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
        [ startdate, enddate, status, payment, employ_sid, cust_id, room_id, hotel_id ]
      );
  
      res.json(newRenting.rows);
    } catch (err) {
      console.error("Insert renting error:", err.message);
      res.status(500).json({ success: false, message: err.message });
    }
  });
  

module.exports = router;
