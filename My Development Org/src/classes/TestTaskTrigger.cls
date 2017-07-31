/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTaskTrigger {

    /*static Account acc;
    static Lead lead;
    static Task task1;*/
    
    /**
     * Preparing Test data
     *
    private static void prepare() {
    	acc = new Account(Name = 'test', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert acc;
    	lead = new Lead(LastName = 'testLead', Company = 'testcompany', Status = 'TestStatus', PostalCode = '72365', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert lead;
    	task1 = new Task(WhatId = acc.id,  Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(3));
    	insert task1;
    	task1 = new Task(WhoId = lead.id,  Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(-8));
    	insert task1;
    }
    
    private static List<sObject> prepareMassInsert() {
    	acc = new Account(Name = 'test', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert acc;
    	lead = new Lead(LastName = 'testLead', Company = 'testcompany', Status = 'TestStatus', PostalCode = '72365', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert lead;
    	List<sObject> toInsert = new List<sObject>();
    	Task massTask;
    	for (Integer i = 0; i < 2000; i++) {
    		massTask = new Task(WhatId = acc.id,  Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(i + 4));
    		toInsert.add(massTask);
    	} 
    	return toInsert;
    }*/
    
    
    /**
     * Test inserting tasks
     *
    private static TestMethod void testTaskInsert() {
        prepare();
        Task task2 = new Task(WhatId = acc.id, Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(-2));
        insert task2;
        
        // Assert last activity field is updated
        acc = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :acc.id];
        System.assertEquals(acc.Last_Activity_Past__c, 2.0);
        System.assertEquals(acc.Last_Activity_Date_Past__c, task2.ActivityDate);
        System.assertEquals(acc.Last_Activity_ID_Past__c, task2.id);
        
        task2 = new Task(WhoId = lead.id,  Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(-2));
    	insert task2;
        
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, 2);
        System.assertEquals(lead.Last_Activity_Date_Past__c, task2.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, task2.id);
    }*/
    
    /**
     * Test Updating Tasks
     *
    private static TestMethod void testeTaskUpdate() {
    	prepare();
    	// Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, 8);
        System.assertEquals(lead.Last_Activity_Date_Past__c, task1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, task1.id);
        
        task1.ActivityDate = Date.today().addDays(1);
        update task1;
        
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Future__c, -1);
        System.assertEquals(lead.Last_Activity_Date_Future__c, task1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Future__c, task1.id);
    	
    }*/
    
    /**
     * Test deleting tasks
     *
    private static TestMethod void testTaskDelete() {
    	prepare();
    	// Assert Setup is correct
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, 8);
        System.assertEquals(lead.Last_Activity_Date_Past__c, task1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, task1.id);
        
        delete task1;
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, null);
        System.assertEquals(lead.Last_Activity_Date_Past__c, null);
        System.assertEquals(lead.Last_Activity_ID_Past__c, null);
    }
    
    private static TestMethod void testMassData() {
    	List<sObject> toInsert = prepareMassInsert();
    	Test.startTest();
    	insert toInsert;
    	Test.stopTest();
    	
    	acc = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :acc.id];
        System.assertEquals(acc.Last_Activity_Future__c, -4);
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(acc.Last_Activity_Future__c, -4);
    }*/
    
    
    
}