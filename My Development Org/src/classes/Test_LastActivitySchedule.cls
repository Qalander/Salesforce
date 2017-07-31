@isTest
global class Test_LastActivitySchedule {
    
		@isTest    
		static void testSchedule() {
        
        Test.startTest();
        
        LastActivitySchedule batch = new LastActivitySchedule();
		String cron_exp = '0 0 * * * ?';
		batch.startSchedule();        
        
        
        Test.stopTest();
    }
	    

    public static String cron_exp = '0 0 * * * ?';
    
    
    @isTest
    public static void testBatch()
    {
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        objAcc.Phone = '+4987412698';
        objAcc.Website = 'www.test.com';
        objAcc.Industry = 'KFZ';
        objAcc.industry_detail__c = 'Autogas';
        
        insert objAcc;
        
        Test.startTest();
        
        
        
        //Test.setMock(System.interfaceType, mock);
        
        //LastActivitySchedule las = new LastActivitySchedule();
        //las.startSchedule();
        
        LastActivityBatch batch = new LastActivityBatch();
        batch.setAccountLeadSelection(1);
		Database.executeBatch(batch);
	
        
        //insertTestData();
        
         // Schedule the test job
      	String jobId = System.schedule('ScheduleApexClassTest',
                        cron_exp, 
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
    }
}