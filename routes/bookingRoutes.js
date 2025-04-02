const express = require('express');
const db = require("../src/databasepg");
const router = express.Router();

// Create a booking

router.post("/booking", async(req, res) => {
    try{
        const {checkindate, checkoutdate, status, cust_id, room_id, hotel_id} = req.body;

        const newBooking = await db.query(
            'INSERT INTO public.booking (chekindate, checkoutdate, status, cust_id, room_id, hotel_id) VALUES ($1, $2, $3, $4, $5, $6)',
            [checkindate, checkoutdate, status, cust_id, room_id, hotel_id]
        );
        res.json(newBooking.rows);
    } catch (err){
        console.error(err.message);
    }
})

// Delete a booking

router.delete("/booking", async(req, res)=>{
    try{
        const bookingID = req.body.booking_id;

        const deleteBooking = await db.query(
            'DELETE FROM booking WHERE booking_id = $1', [bookingID]
        );
        res.json("Booking was deleted");
    } catch (err){
        console.error(err.message);
        res.status(500).json({ error: "Failed to delete booking"});
    }
});

// Get all bookings

router.get("/booking", async(req, res)=>{
    try{
        const allBookings = await db.query("Select * from booking");
        res.json(allBookings.rows);

    }catch(err){
        console.error(err.message);
    }
})

module.exports = router;