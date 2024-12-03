const express = require('express');  // Import the express module
const app = express();  // Create an Express app instance

const port = 3000;

// Health check route
app.get('/health', (req, res) => {
  res.status(200).send('Healthy');
});

// Main route
app.get('/', (req, res) => {
  res.status(200).send('Hello from the Blue environment!');
});

// Start the server and listen on port 3000
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
