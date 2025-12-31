import app from './src/app.js';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import express from 'express';
dotenv.config();
mongoose.connect(process.env.MONGO_URI)
.then(()=>{
     console.log("Connected to MongoDB");
})
.catch((error)=>{
    console.log("Error connecting to MongoDB", error);
});
const PORT = 5000;
app.listen(PORT,()=> {
     console.log(`Server is running on port ${PORT}`);
})