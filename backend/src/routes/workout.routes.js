import express from "express";
import {logWorkout, getLast7Days, getbodypartstats, getStreak } from "../controllers/workout.controller.js";
import { protect } from "../middlewares/authmiddleware.js";

const router = express.Router();
router.post("/log", protect, logWorkout);
router.get("/last7days", protect, getLast7Days);
router.get("/bodypartstats", protect, getbodypartstats);
router.get("/streak", protect, getStreak);
export default router;
