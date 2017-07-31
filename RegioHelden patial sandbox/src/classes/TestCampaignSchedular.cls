@isTest
public class TestCampaignSchedular 
{
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	
	@isTest
    public static void testCampaignSchedular()
    {
        Test.startTest();
        
        CampaignSchedular CS = new CampaignSchedular();
        CS.scheduleMe();
        insertTestData();
        
         // Schedule the test job
      	String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new CampaignSchedular());
        
        // Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
     	System.assertEquals(CRON_EXP, 
        ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
        
        Campaign c =  [SELECT Id, Brutto_Calls__c FROM Campaign LIMIT 1];
        
        System.assertEquals(2, c.Brutto_Calls__c);
    }
    @isTest
    private static void insertTestData()
    {
    	Campaign campaign = new Campaign(EndDate=System.today() + 7, StartDate=System.today(), Name='Test Campaign');
    	insert campaign;
    	Lead lead = new Lead(lastname='Test', company='Test_Company', phone='ka');
    	insert lead;
    	Task task1 = new Task(Subject='Anruf', ActivityDate=System.today(), Status='Completed', Priority='Normal', Type='Andere', WhoId=lead.id);
    	insert task1;
    	Task task2 = new Task(Subject='Anruf',Result__c='Entscheider erreicht', ActivityDate=System.today(), Status='Completed', Priority='Normal', Type='Andere', WhoId=lead.id);
    	insert task2;
    	
    	Account a = new Account(Name='Test Account', Phone='+4914141414');
    	insert a;
    	
    	Contact c = new Contact(Firstname='Test', Lastname='Contact', AccountId=a.id, Phone='+4912345678');
    	insert c;
    	
    	Event e1 = new Event(Subject='Event', ActivityDate=System.today(), Type='Andere', WhoId=c.id, DurationInMinutes=55, ActivityDateTime=System.today());
    	insert e1;
    	
    	CampaignMember member1 = new CampaignMember(campaignId = campaign.Id, leadId = lead.Id);
    	insert member1;
    	
    	CampaignMember member2 = new CampaignMember(campaignId = campaign.Id, contactId = c.Id);
    	insert member2;
    	
    	Lead test = [SELECT Id, (SELECT Id FROM Tasks) FROM Lead LIMIT 1];
    }
}