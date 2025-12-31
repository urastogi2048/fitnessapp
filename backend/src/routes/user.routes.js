import express from "express";
import { protect } from "../middlewares/authmiddleware.js";
import { saveProfile } from "../controllers/user.controller.js";

const router = express.Router();

router.get("/me", protect, (req, res) => {
  res.json({
    message: "Protected route accessed",
    user: req.user,
  });
});
router.post("/profile", protect, saveProfile);

export default router;
