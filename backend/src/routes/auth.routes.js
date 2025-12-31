import express from "express";
import { signupcontroller } from "../controllers/auth.controller.js";
import { logincontroller } from "../controllers/auth.controller.js";
const routes = express.Router();

routes.post("/signup",signupcontroller);
routes.post("/login",logincontroller);
export default routes;