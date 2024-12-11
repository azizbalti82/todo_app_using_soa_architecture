const express = require("express"); //for server
const bodyParser = require("body-parser"); //json conversation
const dotenv = require("dotenv"); //to load sensetive data from .env file
const mailRoute = require("./routes/mailRoute")


// Initialize app
dotenv.config();
const app = express();

// Middleware
app.use(bodyParser.json());
app.use(mailRoute);


// Start server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`User service running on port ${PORT}`);
});

