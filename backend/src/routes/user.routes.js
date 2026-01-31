import express from "express";
import { protect } from "../middlewares/authmiddleware.js";
import { saveProfile } from "../controllers/user.controller.js";

const router = express.Router();

router.get("/me", protect, (req, res) => {
  const user = req.user;
  
  console.log('/user/me called for user:', user._id);
  console.log('User data:', {
    id: user._id,
    username: user.username,
    email: user.email,
    onboardingCompleted: user.onboardingCompleted,
    hasProfile: !!user.profile
  });
  
  res.json({
    user: {
      id: user._id,
      username: user.username,
      email: user.email,
      onboardingCompleted: user.onboardingCompleted,
      profile: user.profile,
    },
  });
});

router.post("/profile", protect, saveProfile);
router.put("/profile", protect, saveProfile);


export default router;
