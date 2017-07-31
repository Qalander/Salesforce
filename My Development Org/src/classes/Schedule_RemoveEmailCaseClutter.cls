public class Schedule_RemoveEmailCaseClutter implements schedulable {
	public void scheduleMe()
	{
	Schedule_RemoveEmailCaseClutter msc = new Schedule_RemoveEmailCaseClutter();
    String sch = '0 0 07 * * ?'; 
    String jobID = System.schedule('RemoveEmailCaseClutter', sch, msc);
        
	}
    public void execute(SchedulableContext sc) {
        RemoveEmailCaseClutter b1 = new RemoveEmailCaseClutter ();
        ID batchprocessid = Database.executeBatch(b1,100);
        system.debug('test the Shedule');
    }
}