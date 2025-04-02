const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(cors());

// Routes
const customerRoutes = require("../routes/customerRoutes");
const employeeRoutes = require("../routes/employeeRoutes");
const hotelRoutes = require("../routes/hotelRoutes");
app.use("/api", customerRoutes);
app.use("/api", employeeRoutes);
app.use("/api", hotelRoutes);

// Root endpoint
app.get("/", (req, res) => {
    res.send("Welcome to the e-Hotels API!");
});

// Start server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});