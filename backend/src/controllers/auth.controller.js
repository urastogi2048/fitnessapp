import { generatetoken } from "../utils/jwt.js";
import User from "../models/user.models.js";
import { signupservice } from "../services/auth.services.js";
import { loginservice } from "../services/auth.services.js";
export const signupcontroller =async (req,res)=> {
    try{
    const {username, email, password} =req.body;
    await signupservice({username, email, password});
    res.status(201).json({
        message: "User signed up successfully",
    });}
    catch(error){
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