import express from "express";
import { protect } from "../middlewares/authmiddleware.js";
import { saveProfile } from "../controllers/user.controller.js";
import { decryptProfilePayload } from "../utils/profileEncryption.js";

const router = express.Router();

router.get("/me", protect, (req, res) => {
  const user = req.user;
  const rawProfile = user.profile?.toObject ? user.profile.toObject() : user.profile;
  const profile = decryptProfilePayload(rawProfile || {});

  res.json({
    user: {
      id: user._id,
      username: user.username,
      email: user.email,
      onboardingCompleted: user.onboardingCompleted,
      profile,
    },
  });
});

router.post("/profile", protect, saveProfile);
router.put("/profile", protect, saveProfile);


export default router;
