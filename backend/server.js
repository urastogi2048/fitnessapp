import app from './src/app.js';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import express from 'express';
dotenv.config();

console.log('Attempting to connect to MongoDB...');
console.log('MongoDB URI:', process.env.MONGO_URI ? 'Found' : 'NOT FOUND');

mongoose.connect(process.env.MONGO_URI)
.then(()=>{
     console.log(" Connected to MongoDB successfully");
     console.log("Database name:", mongoose.connection.db.databaseName);
})
.catch((error)=>{
    console.error("Error connecting to MongoDB:", error.message);
    process.exit(1);
});

const PORT =  process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0',()=> {
     console.log(` Server is running on port ${PORT}`);
})