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
        const result = await db.query(`SELECT DISTINCT city FROM public.hotel`);
        res.json(result.rows);
    } catch (error) {
        console.error("Error fetching cities:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// Get hotel and its rooms by name
router.get("/hotel", async (req, res) => {
    const hotelName = req.query.name;

    if (!hotelName) {
        return res.status(400).json({ error: "Hotel name is required" });
    }

    try {
        const hotelResult = await db.query(
            `SELECT * FROM public.hotel WHERE TRIM(LOWER(hotel_name)) = TRIM(LOWER($1))`,
            [hotelName]
        );

        if (hotelResult.rows.length === 0) {
            return res.status(404).json({ error: "Hotel not found" });
        }

        const hotel = hotelResult.rows[0];

        const roomsResult = await db.query(`
            SELECT r.* 
            FROM public.room r
            JOIN public.hotel h ON r.hotel_id = h.hotel_id
            WHERE TRIM(LOWER(h.hotel_name)) = TRIM(LOWER($1))
        `, [hotelName]);

        hotel.rooms = roomsResult.rows;
        res.json(hotel);
    } catch (error) {
        console.error("Error fetching hotel details:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

module.exports = router;