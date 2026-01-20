import User from "../models/user.models.js";
import { hashPassword } from "../utils/password.js";
import { comparePassword } from "../utils/password.js";
export const signupservice = async ({username, email, password}) => {
    try {
        console.log('🔍 SIGNUP_SERVICE: Checking for existing user with email:', email);
        const existingUser = await User.findOne({email});
        if(existingUser){
            console.log('❌ SIGNUP_SERVICE: User already exists');
            throw new Error("User already exists with this email");
        }
        
        console.log('🔐 SIGNUP_SERVICE: Hashing password...');
        const hashedPassword = await hashPassword(password);
        
        console.log('💾 SIGNUP_SERVICE: Creating user in database...');
        const newUser = await User.create({
            username,
            email,
            password: hashedPassword,
        });
        
        console.log('✅ SIGNUP_SERVICE: User created successfully with ID:', newUser._id);
        return newUser;
    } catch (error) {
        console.error('❌ SIGNUP_SERVICE: Error during signup:', error.message);
        throw error;
    }
}
export const loginservice = async ({ email, password }) => {
    const user = await User.findOne({ email });

    if (!user) {
        throw new Error("Invalid email or password");
    }

    const isPasswordValid = await comparePassword(password, user.password);

    if (!isPasswordValid) {
        throw new Error("Invalid email or password");
    }

    return user;
};

