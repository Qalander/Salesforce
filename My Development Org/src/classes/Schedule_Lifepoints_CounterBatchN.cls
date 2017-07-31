public class Schedule_Lifepoints_CounterBatchN implements schedulable
{
    public static String sched = '0 0 05 * * ?';  //Every Day at 05:00 o'clock 
 //For scheduling --> Schedule_Lifepoints_CounterBatch.scheduleMe();
    public static String scheduleMe() { 
        Schedule_Lifepoints_CounterBatchN SC = new Schedule_Lifepoints_CounterBatchN();
        if(!Test.isRunningTest())
			return System.schedule('Batch LifepointsCounter', sched, SC); 
		else
			return System.schedule('Batch LifepointsCounter_Test', sched, SC);
    	
    }

    public void execute(SchedulableContext sc) {

            LifepointsCounterN b1 = new LifepointsCounterN ();
        if(!Test.isRunningTest())
       		ID batchprocessid = Database.executeBatch(b1,1); 
              
    }
}