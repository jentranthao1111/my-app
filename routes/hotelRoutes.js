const express = require('express');
const db = require("../src/databasepg");
const router = express.Router();

// get hotels by city
router.get("/hotels", async (req, res) => {
    const { city } = req.query;

    if (!city) {
        return res.status(400).json({ error: "City parameter is required" });
    }

    try {
        const result = await db.query(
            `SELECT * FROM public.hotel WHERE city = $1`,
            [city]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: "No hotels found for this city" });
        }

        res.json(result.rows);
    } catch (error) {
        console.error("Error fetching hotels:", error.message);
        res.status(500).json({ error: "Internal server error" });
    }
});


// Get distinct cities
router.get("/cities", async (req, res) => {
    try {
        const result = await db.query('SELECT DISTINCT city FROM public.hotel');
        //const result = await db.query('select * from public.room where hotel_id = 1');
        res.json(result.rows);
    } catch (error) {
        console.error("Error fetching cities:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
});



// Get rooms by hotel ID
router.get('/hotels/:hotelId/rooms', async (req, res) => { 
    const { hotelId } = req.params;

    try {
        // First verify hotel exists
        const hotelCheck = await db.query(
            `SELECT * FROM public.hotel WHERE hotel_id = $1`,
            [hotelId]
        );

        if (hotelCheck.rows.length === 0) {
            return res.status(404).json({ error: "Hotel not found" });
        }

        // Get rooms for this hotel
        const roomsResult = await db.query(
            `SELECT * FROM public.room WHERE hotel_id = $1`,
            [hotelId]
        );

        res.json({
            hotel: hotelCheck.rows[0],
            rooms: roomsResult.rows
        });
    } catch (error) {
        console.error("Error fetching rooms:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});


module.exports = router;