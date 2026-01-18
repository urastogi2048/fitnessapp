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
export const getStreak=async(userId)=> {
    const user=await User.findById(userId);
    if(!user) throw new Error("User not found");
    const workouts=user.workoutstat;
    if(workouts.length===0) {
        return {streak:0};
    }
    const workoutDaysSet=new Set();
    workouts.forEach((stat) => {
        const d=normaliseDate(stat.day);
        workoutDaysSet.add(d.getTime());
    });
    const workoutDays=Array.from(workoutDaysSet).map(time=>new Date(time)).sort((a,b)=>a-b);
    const today=normaliseDate(new Date());
    let currentStreak=0;
    let checkDate=new Date(today);
    while(true){
        const found= workoutDays.some(d=>d.getTime()===checkDate.getTime());
        if(found){
            currentStreak++;
            checkDate.setDate(checkDate.getDate()-1);
        }
        else break;
        
    }
    const todayHasWorkout=workoutDays.some(d=>d.getTime()===today.getTime());
    if(!todayHasWorkout){
        currentStreak=0;
    }
    let longestStreak=1;
    let tempStreak=1;
    for(let i=1;i<workoutDays.length;i++){
        const prevDay= workoutDays[i-1];
        const currDay= workoutDays[i];
        const diffTime=currDay.getTime()- prevDay.getTime();
        const diffDays= diffTime/(1000*3600*24);
        if(diffDays===1){
            tempStreak++;
            longestStreak=Math.max(longestStreak,tempStreak);

        }
        else {
            tempStreak=1;
        }

    }
    if(workoutDays.length===1){
        longestStreak=1;
    }
    const lastWorkoutDay= workoutDays[workoutDays.length-1];
    return {
        currentStreak,
        longestStreak,
        lastWorkoutDay: lastWorkoutDay.toISOString().slice('T')[0],
    }




}