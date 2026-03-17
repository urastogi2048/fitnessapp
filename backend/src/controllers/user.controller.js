import User from "../models/user.models.js";
import { encryptProfilePayload } from "../utils/profileEncryption.js";

function normalizeNumber(value, field) {
    const n = Number(value);
    if (!Number.isFinite(n)) {
        throw new Error(`${field} must be a valid number`);
    }
    return n;
}

function validateProfileInput({ age, gender, height, weight, goal, bodyType }) {
    const parsedAge = normalizeNumber(age, "age");
    const parsedHeight = normalizeNumber(height, "height");
    const parsedWeight = normalizeNumber(weight, "weight");

    if (parsedAge < 13 || parsedAge > 100) {
        throw new Error("age must be between 13 and 100");
    }

    if (parsedHeight < 50 || parsedHeight > 300) {
        throw new Error("height must be between 50 and 300");
    }

    if (parsedWeight < 20 || parsedWeight > 500) {
        throw new Error("weight must be between 20 and 500");
    }

    const normalizedGender = String(gender || "").toLowerCase();
    if (!["male", "female"].includes(normalizedGender)) {
        throw new Error("gender must be either 'male' or 'female'");
    }

    const normalizedBodyType = String(bodyType || "").trim().toLowerCase();
    const normalizedGoal = String(goal || "").trim().toLowerCase();

    if (!normalizedBodyType) {
        throw new Error("bodyType is required");
    }

    if (!normalizedGoal) {
        throw new Error("goal is required");
    }

    return {
        age: parsedAge,
        gender: normalizedGender,
        height: parsedHeight,
        weight: parsedWeight,
        bodyType: normalizedBodyType,
        goal: normalizedGoal,
    };
}

export const saveProfile = async (req, res) => {
    try {
        const userId = req.user.id;

        const {
            age,
            gender,
            height,
            weight,
            goal,
            bodyType
        } = req.body;

        const normalizedProfile = validateProfileInput({
            age,
            gender,
            height,
            weight,
            goal,
            bodyType,
        });

        const encryptedProfile = encryptProfilePayload(normalizedProfile);

        await User.findByIdAndUpdate(
            userId,
            {
                profile: encryptedProfile,
                onboardingCompleted: true,
            },
            { new: true, runValidators: true }
        );

        res.status(200).json({
            message: "Profile saved successfully",
        });
    }
    catch (error) {
        const statusCode = error.message?.includes("must") || error.message?.includes("required")
            ? 400
            : 500;

        res.status(statusCode).json({
            message: "Failed to save profile",
            error: error.message,
        });
    }
};
