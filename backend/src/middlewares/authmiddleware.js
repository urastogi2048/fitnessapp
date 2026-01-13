import jwt from "jsonwebtoken";
import User from "../models/user.models.js";

export const protect = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    console.log('🔐 AUTH CHECK:', { authHeader: authHeader ? 'Present' : 'Missing' });

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      console.log('❌ No Bearer token');
      return res.status(401).json({ error: "Not authorized - missing Bearer token" });
    }

    const token = authHeader.split(" ")[1];
    console.log('📝 Token received:', token.substring(0, 20) + '...');
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log('✅ Token verified, userId:', decoded.id);

    const user = await User.findById(decoded.id).select("-password");
    if (!user) {
      console.log('❌ User not found in DB');
      return res.status(401).json({ error: "User not found" });
    }

    console.log('✅ User found:', user.username);
    req.user = user;
    next();
  } catch (error) {
    console.log('❌ Auth error:', error.message);
    console.log('   Full error:', error);
    res.status(401).json({ error: "Invalid or expired token: " + error.message });
  }
};
