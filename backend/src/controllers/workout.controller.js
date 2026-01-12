import * as workoutService from '../services/workout.services.js';
export const logWorkout = async (req, res) => {
    try {
        const {duration,bodyPart} = req.body;
        if(!duration || duration<1){
            return res.status(400).json({message: "Invalid duration"});
        }
        if(!bodyPart) {
            return res.status(400).json({message: "Body part is required"});
        }
    await workoutService.logWorkout({
        userId:req.user.id,
        duration,
        bodyPart,
    });
    res.status(200).json({message: "Workout logged successfully"});
    } catch (error) {
    res.status(500).json({message: error.message});
    }
};
export const getLast7Days = async (req, res) => {
    try {
        const data = await workoutService.getLast7Days(req.user.id);
        res.status(200).json(data);
    } catch (error) {
        res.status(500).json({message: error.message});
    };
}
export const getbodypartstats=async (req,res)=> {
    try {
        const data =await workoutService.getBodyPartStats(req.user.id);
        res.status(200).json(data);
    }
    catch (error) {
        res.status(500).json({message: error.message});
    }
}