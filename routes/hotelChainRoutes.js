const express = require("express");
const db = require("../src/databasepg");
const router = express.Router();

// GET all hotel chains
router.get("/", async (req, res) => {
    try {
        const result = await db.query(`
            SELECT * FROM public.hotel_chain`
        );
        res.json(result.rows);
    } catch (error) {
        console.error("Error fetching hotel chains:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

// GET hotels by hotel chain ID
router.get("/hotels", async (req, res) => {
    const { chainId } = req.query;

    if (!chainId) {
        return res.status(400).json({ error: "chainId parameter is required" });
    }

    try {
        const result = await db.query(`
            SELECT * FROM public.hotel
            WHERE hotel_chain_id = $1`,
            [chainId]);

        res.json(result.rows);
    } catch (error) {
        console.error("Error fetching hotels by chain ID:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

module.exports = router;