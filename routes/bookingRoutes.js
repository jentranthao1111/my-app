const express = require('express');
const db = require("../src/databasepg");
const router = express.Router();

// Create a booking
router.post("/booking", async (req, res) => {
  try {
    const { checkindate, checkoutdate, status, cust_id, room_id, hotel_id } = req.body;

    const newBooking = await db.query(
      'INSERT INTO public.booking ("checkindate", "checkoutdate", "status", "cust_id", "room_id", "hotel_id") VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [checkindate, checkoutdate, status, cust_id, room_id, hotel_id]
    );

    res.json(newBooking.rows);
  } catch (err) {
    console.error("Insert booking error:", err.message);
    res.status(500).json({ success: false, message: err.message });
  }
});

// Delete a booking
router.delete("/booking/:id", async (req, res) => {
  try {
    const bookingID = req.params.id;

    const deleteBooking = await db.query(
      'DELETE FROM booking WHERE booking_id = $1', [bookingID]
    );

    res.json({ success: true, message: "Booking was deleted" });
  } catch (err) {
    console.error("Delete booking error:", err.message);
    res.status(500).json({ success: false, message: "Failed to delete booking" });
  }
});


// Get all bookings
router.get("/booking", async (req, res) => {
  try {
    const allBookings = await db.query('SELECT * FROM public.booking');
    res.json(allBookings.rows);
  } catch (err) {
    console.error("Fetch bookings error:", err.message);
    res.status(500).json({ success: false, message: "Failed to fetch bookings" });
  }
});

//get bookings for certain customers
router.get("/booking/cust_id/:cust_id", async (req, res) => {
  try {
    const { cust_id } = req.params;

    const result = await db.query(
      `SELECT b.*, h.hotel_name AS "Hotel_Name"
       FROM public.booking b
       JOIN public.hotel h ON b.hotel_id = h.hotel_id
       WHERE b.cust_id = $1`,
      [cust_id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Fetch user bookings error:", err.message);
    res.status(500).json({ success: false, message: "Failed to fetch user bookings" });
  }
});

module.exports = router;
