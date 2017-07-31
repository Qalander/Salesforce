@isTest
public class Test_Schedule_RemoveEmailCaseClutter {

    static testmethod void testschedule() {
        
        Test.startTest();
        
        Schedule_RemoveEmailCaseClutter batch = new Schedule_RemoveEmailCaseClutter();
		String cron_exp = '0 0 07 * * ?';
        batch.scheduleMe();
        
        system.schedule('Test', cron_exp, batch);
        
        Test.stopTest();
    }
}