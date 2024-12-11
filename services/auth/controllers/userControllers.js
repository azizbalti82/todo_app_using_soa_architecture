const User = require('../models/userModel');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const axios = require('axios');


// Register a new user
const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Check if the user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const user = new User({
      name,
      email,
      password: hashedPassword,
    });

    // Save the user to the database
    await user.save();

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error });
  }
};

// Login an existing user
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Check the password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Generate a JWT token
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });

    // Now send an email using your email API with user's name and email
    try {
      const emailResponse = await axios.post(
        'http://192.168.1.18:5001/new/mail/', // Email API URL
        {
          name: user.name,  // Assuming the user object has a 'name' field
          email: user.email, // User's email
        }
      );

      console.log('Email sent successfully:', emailResponse.data); // Log if needed

    } catch (emailError) {
      console.error('Error sending email:', emailError.message); // Log any errors with email API
    }

    res.status(200).json({ message: 'Login successful', token });

  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error });
  }
};



module.exports = { register, login };
