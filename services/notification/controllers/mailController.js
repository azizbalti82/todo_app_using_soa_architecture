const nodemailer = require('nodemailer');
const dotenv = require('dotenv');
dotenv.config(); // Load environment variables from .env file

// Create a transporter for sending emails
const transporter = nodemailer.createTransport({
  service: 'gmail',  // You can change this to any email provider
  auth: {
    user: process.env.EMAIL_USER,  // Get email from .env
    pass: process.env.EMAIL_PASS,  // Get password from .env
  },
});

transporter.verify((error, success) => {
  if (error) {
    console.log('Error with transporter:', error);
  } else {
    console.log('Transporter is ready to send emails:', success);
  }
});

// Function to send notification email
const newMail = async (req, res) => {
  try {
    const { name, email } = req.body;

    if (!name || !email) {
      return res.status(400).json({ message: "Name and email are required." });
    }

    // Compose the email content
    const subject = "New Device Login Notification";
    const message = `Hello ${name},\n\nA new device has logged in using your email address: ${email}.\n\nIf this wasn't you, please take the necessary action.`;

    // Set up the email options
    const mailOptions = {
      from: process.env.EMAIL_USER,  // Sender email from .env
      to: email,  // Recipient email (the one passed in the body)
      subject: subject,  // Email subject
      text: message,  // Email body
    };

    // Send the email
    await transporter.sendMail(mailOptions);

    // Respond with a success message
    res.status(200).json({ message: 'Email sent successfully!' });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({ message: 'Error sending email', error });
  }
};

module.exports = { newMail };
