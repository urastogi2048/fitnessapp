import app from './src/app.js';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import express from 'express';
dotenv.config();

mongoose.connect(process.env.MONGO_URI)
.then(()=>{
})
.catch((error)=>{
    process.exit(1);
});

const PORT =  process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0',()=> {
})