import * as workoutService from '../services/workout.services.js';
import User from '../models/user.models.js';
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
export const getStreak=async(req,res)=> {
    try{
        const data=await workoutService.getStreak(req.user.id);
        res.status(200).json({streak:data});
    
    }
    catch(error){
        res.status(500).json({message:error.message});
    }

}
export const getWeeklyDaywise =async(req,res) => {
    try {
        const user=await User.findById(req.user.id);
        if(!user) {
            return res.status(404).json({message: "User not found"});
        }
        const today=new Date();
        const sevenDaysAgo=new Date(today.getTime() - 6*24*60*60*1000);
        const weeklyWorkouts=user.workoutstat.filter((workout)=> {
            return new Date(workout.day)>= sevenDaysAgo;
        })
        const dayNames=['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        const dayTotals=[0,0,0,0,0,0,0];
        weeklyWorkouts.forEach((workout)=> {
            const dayOfWeek=new Date(workout.day).getDay();
            dayTotals[dayOfWeek] += workout.duration;

        });
        const result = dayNames.map((name,idx)=> ({
            day:name,
            totalSeconds: dayTotals[idx],
        totalMinutes: Math.round(dayTotals[idx]/60),

        }));
        res.json(result);



       


    }
    catch(error) {
        res.status(500).json({message: error.message});
    }
};
export const getWeeklyBodyPart = async(req,res) => {
    try {
        const user = await User.findById(req.user.id);
        if(!user) {
            return res.status(404).json({message: 'User not found'});

        }
        const today=new Date();
        const sevenDaysAgo=new Date(today.getTime() - 6*24*60*60*1000);
        const weeklyWorkouts = user.workoutstat.filter((workout)=>{
            return new Date(workout.day) >= sevenDaysAgo;

        });
        const bodyPartTotals={};
        weeklyWorkouts.forEach((workout)=> {
            if(!bodyPartTotals[workout.bodyPart]){
                bodyPartTotals[workout.bodyPart]=0;
            }
            bodyPartTotals[workout.bodyPart] += workout.duration;


        });
        const result = Object.entries(bodyPartTotals).map(([bodyPart,totalSeconds])=> ({
            bodyPart,
            totalSeconds,
            totalMinutes: Math.round(totalSeconds/60),
        }));
        res.json(result);

    }
    catch(e){
        res.status(500).json({message: e.message});
    }
};

export const getGrowth30Day = async(req,res) => {
    try {
        const user=await User.findById(req.user.id);
        if(!user) {
            return res.status(404).json({message: "User not found"});
        }       
        const today=new Date();
        today.setHours(0,0,0,0);
        const thirtyDaysAgo=new Date(today.getTime() - 29*24*60*60*1000);
        const dayMap={};
        for(let i=0; i<30; i++){
            const date=new Date(thirtyDaysAgo.getTime() + i*24*60*60*1000);
            const dateStr=date.toISOString().split('T')[0];
            dayMap[dateStr]=0;
        }
        user.workoutstat.forEach((workout)=> {
            const workoutDate=new Date(workout.day);
            workoutDate.setHours(0,0,0,0);
            const dateStr=workoutDate.toISOString().split('T')[0];
            if(dayMap[dateStr]!==undefined)     {
                dayMap[dateStr] += workout.duration;
            }
        });
        const result = Object.entries(dayMap).map(([date,totalSeconds])=> ({
            date,
            totalSeconds,
            totalMinutes: Math.round(totalSeconds/60),
              } ));
        res.json(result);

    }
    catch(e) {
        res.status(500).json({message: e.message});
     }
};
export const getBodyPartDistribution = async (req,res)=> {
    try {
        const user=await User.findById(req.user.id);
        if(!user) {
            return res.status(404).json({message: "User not found"});
        }
        const today=new Date();
        const thirtyDaysAgo=new Date(today.getTime() - 29*24*60*60*1000);
        const filtered=user.workoutstat.filter((workout)=> new Date(workout.day)>=thirtyDaysAgo);
        const bodyPartTotals={};
        let grandTotal=0;
        filtered.forEach((workout)=> {
            if(!bodyPartTotals[workout.bodyPart]) {
                bodyPartTotals[workout.bodyPart]=0;
            }
            bodyPartTotals[workout.bodyPart]+=workout.duration;
            grandTotal += workout.duration;

        });
        const result=Object.entries(bodyPartTotals).map(([bodyPart,totalSeconds])=> ({
            bodyPart,
            totalSeconds,
            totalMinutes: Math.round(totalSeconds/60),
            percentage: grandTotal ? ((totalSeconds / grandTotal)*100).toFixed(2) : 0,
        }));
        res.json(result);   


    }
    catch(e){
        res.status(500).json({message: e.message});
    }
    
}
