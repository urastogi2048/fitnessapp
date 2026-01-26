import express from "express";
import {logWorkout, getLast7Days, getbodypartstats, getStreak, getWeeklyDaywise, getWeeklyBodyPart, getGrowth30Day, getBodyPartDistribution } from "../controllers/workout.controller.js";
import { protect } from "../middlewares/authmiddleware.js";

const router = express.Router();
router.post("/log", protect, logWorkout);
router.get("/last7days", protect, getLast7Days);
router.get("/bodypartstats", protect, getbodypartstats);
router.get("/streak", protect, getStreak);
router.get("/stats/weekly-daywise", protect, getWeeklyDaywise);
router.get("/stats/weekly-bodypart", protect, getWeeklyBodyPart);
router.get("/stats/growth-30day", protect, getGrowth30Day);
router.get("/stats/bodypart-distribution", protect, getBodyPartDistribution);
export default router;
