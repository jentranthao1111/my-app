const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(cors());

// Routes
const customerRoutes = require("../routes/customerRoutes");
app.use("/api", customerRoutes);

// Root endpoint
app.get("/", (req, res) => {
    res.send("Welcome to the e-Hotels API!");
});

// Start server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});