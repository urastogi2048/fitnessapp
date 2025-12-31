import mongoose from "mongoose";

const UserSchema = new mongoose.Schema(
{
    username: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
    },
    password: {
        type: String,
        required: true,
    },

    profile: {
        age: {
            type: Number,
            min: 10,
            max: 100,
        },
        gender: {
            type: String,
            enum: ["male", "female"],
        },
        weight: Number,   // kg
        height: Number,   // cm
        bodyType: String,
        goal: String,
    },

    onboardingCompleted: {
        type: Boolean,
        default: false,
    },
},
{ timestamps: true }
);

const User = mongoose.model("User", UserSchema);
export default User;
