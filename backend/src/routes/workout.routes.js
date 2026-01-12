import express from "express";
import {logWorkout, getLast7Days, getbodypartstats } from "../controllers/workout.controller.js";
import { protect } from "../middlewares/authmiddleware.js";

const router = express.Router();
router.post("/log", protect, logWorkout);
router.get("/last7days", protect, getLast7Days);
router.get("/bodypartstats", protect, getbodypartstats);
export default router;