const express = require('express');
var http = require('http');
// const socketIo = require('socket.io');

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app).listen(port, '192.168.79.178'); 
const io = require('socket.io')(server);
server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const buyers = []; // Store connected buyers

io.on('connection', (socket) => {
  console.log('A user connected');

  // Handle events here

  socket.on('register_buyer', (buyerInfo) => {
    
    buyers.push({
      socketId: socket.id,
      
      buyerName: buyerInfo.buyerName,
      buyerLocation : buyerInfo.buyerLocation
    });
    console.log(`Buyer registered: ${socket.id}`);
  });

  socket.on('pickup_request', (data) => {
    // Handle pickup request here
    console.log('Pickup request received:', data);

    // Broadcast the pickup request to all connected buyers
    buyers.forEach((buyer) => {
      io.to(buyer.socketId).emit('pickup_request', data);
    });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');

    // Remove the disconnected buyer from the buyers array
    const index = buyers.findIndex((buyer) => buyer.socketId === socket.id);
    if (index !== -1) {
      buyers.splice(index, 1);
      console.log(`Buyer removed: ${socket.id}`);
    }
  });
});