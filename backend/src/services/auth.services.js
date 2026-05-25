import User from "../models/user.models.js";
import { hashPassword } from "../utils/password.js";
import { comparePassword } from "../utils/password.js";

export const signupservice = async ({username, email, password}) => {
    try {
        // CRITICAL: Normalize email everywhere
        const normalizedEmail = email.trim().toLowerCase();
        // CRITICAL: Trim password to prevent whitespace issues
        const trimmedPassword = password.trim();
        
        const existingUser = await User.findOne({email: normalizedEmail});
        if(existingUser){
            throw new Error("User already exists with this email");
        }

        const hashedPassword = await hashPassword(trimmedPassword);

        const newUser = await User.create({
            username,
            email: normalizedEmail,
            password: hashedPassword,
        });

        console.log('Signup successful:', normalizedEmail);
        return newUser;
    } catch (error) {
        console.error('Signup error:', error.message);
        throw error;
    }
}

export const loginservice = async ({ email, password }) => {
    try {
        // CRITICAL: Normalize email same as signup
        const normalizedEmail = email.trim().toLowerCase();
        // CRITICAL: Trim password same as signup
        const trimmedPassword = password.trim();
        
        console.log('Login: searching for user', { email: normalizedEmail });
        
        const user = await User.findOne({ email: normalizedEmail });

        if (!user) {
            console.error('User not found:', normalizedEmail);
            throw new Error("Invalid email or password");
        }

        const isPasswordValid = await comparePassword(trimmedPassword, user.password);

        if (!isPasswordValid) {
            console.error('Invalid password for user:', normalizedEmail);
            throw new Error("Invalid email or password");
        }

        console.log('Login successful:', normalizedEmail);
        return user;
    } catch (error) {
        console.error('Login error:', error.message);
        throw error;
    }
};

