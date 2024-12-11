const express = require("express"); //for server
const bodyParser = require("body-parser"); //json conversation
const dotenv = require("dotenv"); //to load sensetive data from .env file
const mongoose = require('mongoose')

//loading my routes
const userRoutes = require("./routes/userRoutes");

//Initialize database
mongoose.connect('mongodb://localhost:27017/todo_service', {})
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('MongoDB connection error:', err));

// Initialize app
dotenv.config();
const app = express();

// Middleware
app.use(bodyParser.json());
app.use("/user", userRoutes);

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`User service running on port ${PORT}`);
});
