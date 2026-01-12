import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth.routes.js';
import userRoutes from './routes/user.routes.js';
import workoutRoutes from './routes/workout.routes.js';

const app = express();

// Enable CORS for all routes
app.use(cors());
app.use(express.json());

app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/workout', workoutRoutes);

export default app;