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
private class TestLastActivitySchedule {

    /*static Account acc;
    static Lead lead;
    static LastActivitySchedule las;
    static LastActivityBatch lab;*/
    
    /**
     * Preparing test data
     *
    private static void prepare() {
    	acc = new Account(Name = 'test', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert acc;
    	lead = new Lead(LastName = 'testLead', Company = 'testcompany', Status = 'TestStatus', PostalCode = '72365', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert lead;
    	acc.Last_Activity_Date_Past__c = Date.today().addDays(-250);
    	acc.Last_Activity_Date_Future__c = Date.today().addDays(250);
    	update acc;
    	lead.Last_Activity_Date_Past__c = Date.today().addDays(-250);
    	lead.Last_Activity_Date_Future__c = Date.today().addDays(250);
    	update lead;
    	Event event1 = new Event(WhatId = acc.id,  Subject = 'Call', StartDateTime = DateTime.now().addDays(3), EndDateTime = DateTime.now().addDays(3), ActivityDate = Date.today().addDays(3));
    	insert event1;
    	event1 = new Event(WhoId = lead.id,  Subject = 'Call', StartDateTime = DateTime.now().addDays(-8), EndDateTime = DateTime.now().addDays(-8), ActivityDate = Date.today().addDays(-8));
    	insert event1;
    	las = new LastActivitySchedule();
    	lab = new LastActivityBatch();
    	lab.setAccountLeadSelection(-2);
    }*/
    
    /*private static List<sObject> prepareMassInsert() {
    	acc = new Account(Name = 'test', Phone = '0049123456', Fax = '0049', Mobiltelefon__c = '0049');
    	insert acc;
    	List<sObject> toInsert = new List<sObject>();
    	Task massTask;
    	for (Integer i = 0; i < 450; i++) {
    		massTask = new Task(WhatId = acc.id,  Subject = 'Call', Priority = 'Normal', ActivityDate = Date.today().addDays(i + 4));
    		toInsert.add(massTask);
    	} 
    	lab = new LastActivityBatch();
    	return toInsert;
    }*/
    
    
    /**
     * Testing batch update of last activity field of all leads and accounts
     *
    private static TestMethod void testLastActivitySchedule() {
    	prepare();
    	Test.startTest();
    	String cron_exp = '0 0 0 * * ?';
		System.schedule('LastActivityUpdate', cron_exp, new LastActivitySchedule());
    	Database.executeBatch(lab);
    	Test.stopTest();
    	las.startSchedule('TestScheduler');
    	
    	// Assert last activity field is updated
    	acc = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :acc.id];
    	System.assertEquals(acc.Last_Activity_Future__c, -3.0);
    	
    	lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
    	System.assertEquals(lead.Last_Activity_Past__c, 8);
    }
    
    /**
     * Test Batch with MassData
     *
    private static TestMethod void testMassDate() {
    	List<sObject> toInsert = prepareMassInsert();
    	insert toInsert;
    	// Assert Tasks are inserted --> Test Setup
    	System.assertEquals([SELECT COUNT() FROM Task WHERE WhatId = :acc.id], 450);
    	
    	// Reset Last Activity Fields
    	acc.Last_Activity_Date_Past__c = null;
    	acc.Last_Activity_ID_Past__c = null;
    	update acc;
    	
    	Test.startTest();
    	Database.executeBatch(lab, 500);
    	Test.stopTest();
    	// Assert last activity field is updated
    	acc = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :acc.id];
    	System.assertEquals(acc.Last_Activity_Future__c, -4);
    	
    }*/
    
    
    
}