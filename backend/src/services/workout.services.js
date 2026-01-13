import User from "../models/user.models.js";
const normaliseDate = (date) => 
    new Date(date.getFullYear(), date.getMonth(), date.getDate());

export const logWorkout = async ({userId, duration, bodyPart}) => {
    const user = await User.findById(userId);
    if(!user) throw new Error("User not found");

    user.workoutstat.push({
        day: new Date(),
        duration,
        bodyPart,
    });
    await user.save();
};

export const getLast7Days = async (userId) => {
    const user = await User.findById(userId);
    if(!user) throw new Error("User not found");

    const today = normaliseDate(new Date());
    const start = new Date(today);
    start.setDate(start.getDate() - 6);

    const result = {};
    for(let i=0; i<7; i++){
        const d = new Date(start);
        d.setDate(start.getDate() + i);
        result [d.toISOString().slice(0,10)] = 0;

    }
    user.workoutstat.forEach((stat) => {
        const d=normaliseDate(stat.day);
        if(d>=start && d<=today){
            const key = d.toISOString().slice(0,10);
            result[key] += stat.duration;

        }
    });
    return result;
}

export const getBodyPartStats = async (userId) => {
    const user = await User.findById(userId);
    if(!user) throw new Error("User not found");

    const result = {};
    user.workoutstat.forEach((stat) => {
        if(!result[stat.bodyPart]){
            result[stat.bodyPart] =0;
        }
        result[stat.bodyPart] += stat.duration;
    });
    return result;
};