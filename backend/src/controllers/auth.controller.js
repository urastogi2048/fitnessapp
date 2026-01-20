import { generatetoken } from "../utils/jwt.js";
import User from "../models/user.models.js";
import { signupservice } from "../services/auth.services.js";
import { loginservice } from "../services/auth.services.js";
export const signupcontroller =async (req,res)=> {
    try{
    console.log('📝 SIGNUP_CONTROLLER: Received signup request');
    console.log('📧 Email:', req.body.email);
    console.log('👤 Username:', req.body.username);
    
    const {username, email, password} =req.body;
    
    if (!username || !email || !password) {
        console.log('❌ SIGNUP_CONTROLLER: Missing required fields');
        return res.status(400).json({
            error: "All fields are required"
        });
    }
    
    await signupservice({username, email, password});
    console.log('✅ SIGNUP_CONTROLLER: User signed up successfully');
    
    res.status(201).json({
        message: "User signed up successfully",
    });}
    catch(error){
        console.error('❌ SIGNUP_CONTROLLER: Error:', error.message);
        res.status(400).json({
            error: error.message,
        });
    }
    

};
export const logincontroller = async (req,res)=>{
    try{
        const {email, password} = req.body;
        const user = await loginservice({email, password});
        const token = generatetoken(
            {
                id: user._id,
                email: user.email,
                username: user.username,
            }
        )
        res.status(200).json({
            message: "User logged in successfully",
            token,
            user: {
                username: user.username,
                email: user.email,
            }
        })
    }
    catch(error){
        res.status(400).json({
            error: error.message,
        });
    }
}