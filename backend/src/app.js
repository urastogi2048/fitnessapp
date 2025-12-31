import express from 'express';
import authRoutes from './routes/auth.routes.js';
import userRoutes from './routes/user.routes.js';
const app = express();
app.use(express.json());
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
export default app;