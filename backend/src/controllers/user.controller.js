import User from "../models/user.models.js";

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

        await User.findByIdAndUpdate(
            userId,
            {
                profile: {
                    age,
                    gender,
                    height,
                    weight,
                    goal,
                    bodyType,
                },
                onboardingCompleted: true,
            },
            { new: true, runValidators: true }
        );

        res.status(200).json({
            message: "Profile saved successfully",
        });
    }
    catch (error) {
        res.status(500).json({
            message: "Failed to save profile",
            error: error.message,
        });
    }
};
