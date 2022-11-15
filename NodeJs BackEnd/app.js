const express = require("express");

const app = express();
const PORT = process.env.PORT || 4000;
const server = app.listen(PORT,()=>{
    console.log("Server started in", PORT);
})
const io = require("socket.io")(server);
io.on('connection',(socket)=>{
    console.log('connected successfully',socket.id);
    socket.on('disconnect',()=>{
        console.log('Disconnected', socket.id);
    });

io.listen(PORT);
    socket.on('message',(data)=>{
        console.log(data);
    });
})
