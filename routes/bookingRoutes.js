const express = require('express');
const db = require("../src/databasepg");
const router = express.Router();

// Create a booking
router.post("/booking", async (req, res) => {
  try {
    const { checkindate, checkoutdate, status, cust_id, room_id, hotel_id } = req.body;

    const newBooking = await db.query(
      'INSERT INTO public."Booking" ("CheckInDate", "CheckOutDate", "Status", "Cust_ID", "Room_ID", "Hotel_ID") VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [checkindate, checkoutdate, status, cust_id, room_id, hotel_id]
    );

    res.json({ success: true, booking: newBooking.rows[0] });
  } catch (err) {
    console.error("Insert booking error:", err.message);
    res.status(500).json({ success: false, message: err.message });
  }
});

// Delete a booking
router.delete("/booking", async (req, res) => {
  try {
    const bookingID = req.body.booking_id;

    const deleteBooking = await db.query(
      'DELETE FROM public."Booking" WHERE "Booking_ID" = $1', [bookingID]
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
    const allBookings = await db.query('SELECT * FROM public."Booking"');
    res.json(allBookings.rows);
  } catch (err) {
    console.error("Fetch bookings error:", err.message);
    res.status(500).json({ success: false, message: "Failed to fetch bookings" });
  }
});

module.exports = router;
