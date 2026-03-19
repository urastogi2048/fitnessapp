import User from "../models/user.models.js";
import { hashPassword } from "../utils/password.js";
import { comparePassword } from "../utils/password.js";
export const signupservice = async ({username, email, password}) => {
    try {
        const existingUser = await User.findOne({email});
        if(existingUser){
            throw new Error("User already exists with this email");
        }

        const hashedPassword = await hashPassword(password);

        const newUser = await User.create({
            username,
            email,
            password: hashedPassword,
        });

        return newUser;
    } catch (error) {
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

