const express = require('express');
const path = require('path');

const app = express();

// Set up static file serving
app.use(express.static(path.join(__dirname, '')));

// Route handler for the homepage
app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(3000, function () {
  console.log("App listening on port 3000!");
});
