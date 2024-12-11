const express = require("express");
const {newMail} = require("../controllers/mailController")

const router = express.Router();

// Routes
router.post("/new/mail/", newMail);

module.exports = router; //make this router usable by other modules
