
const { Client } = require("pg");

const client = new Client({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "YOUR PASSWORD",
    database: "ehotel_csi2132_prj"
});

client.connect()
    .then(() => console.log("Connected to PostgreSQL"))
    .catch(err => console.error("Database connection error:", err));

module.exports = client;
//client.connect();

// test the connection
// client.query(`Select * from public.hotel_chain`, (err,res) => {
//     if(!err){
//         console.log(res.rows);
//     }else{
//         console.log(err.message)
//     }

//     client.end;
// })

//test the connection
// client.query(`Select * from public.hotel`, (err,res) => {
//     if(!err){
//         console.log(res.rows);
//     }else{
//         console.log(err.message)
//     }
//     client.end;
// })

// Define API Endpoint


// app.get('/api/hotels', async (req, res) => {
//     const { city } = req.query;

//     if (!city) {
//         return res.status(400).json({ error: "City parameter is required" });
//     }

//     try {
//         // Query the database using the city parameter
//         const result = await client.query(
//             `SELECT * FROM public.hotel WHERE city = $1`,
//             [city]
//         );

//         if (result.rows.length === 0) {
//             return res.status(404).json({ message: "No hotels found for this city" });
//         }

//         res.json(result.rows);
//     } catch (error) {
//         console.error("Error fetching hotels:", error);
//         res.status(500).json({ error: "Internal server error" });
//     }
// });




// // //Define API Endpoint
// app.get("/api/cities", async (req, res) => {
//     try {
//         const result = await client.query(`SELECT DISTINCT city FROM public.hotel`);
//         res.json(result.rows); // Send JSON response
//     } catch (error) {
//         console.error("Error fetching hotels:", error);
//         res.status(500).json({ error: "Internal Server Error" });
//     }
// });

// // Define API Endpoint for getting rooms by hotel ID
// // Fetch hotel details & rooms by hotel name (RENAMED ROUTE)
// app.get('/api/hotel', async (req, res) => {
//     //const hotelName = req.query.name; // Get the name from query params
//     const hotelName = req.query; // Get the name from query params
//     console.log(req.query.name); // Log the name to verify it's correct

//     if (!hotelName) {
//         return res.status(400).json({ error: "Hotel name is required" });
//     }

//     try {
//         const hotelResult = await client.query(`
//             SELECT * FROM public.hotel WHERE TRIM(LOWER(hotel_name)) = TRIM(LOWER($1))
//         `, [hotelName]);

//         if (hotelResult.rows.length === 0) {
//             return res.status(404).json({ error: "Hotel not found" });
//         }

//         const hotel = hotelResult.rows[0];

//         // Query rooms for the selected hotel
//         const roomsResult = await client.query(`
//             SELECT r.* 
//             FROM public.room r
//             JOIN public.hotel h ON r.hotel_id = h.hotel_id
//             WHERE TRIM(LOWER(h.hotel_name)) = TRIM(LOWER($1))
//         `, [hotelName]);

//         hotel.rooms = roomsResult.rows; // Attach rooms

//         res.json(hotel);
//     } catch (error) {
//         console.error("Error fetching hotel details:", error);
//         res.status(500).json({ error: "Internal Server Error" });
//     }
// });


// // Start Server
// app.listen(port, () => {
//     console.log(`Server running on http://localhost:${port}`);
// });