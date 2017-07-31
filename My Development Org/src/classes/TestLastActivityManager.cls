/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 * 
 * This will test the Last Activity Manager class which sets the last future and last past activity
 */ 
@isTest
private class TestLastActivityManager {

    static Account acc;
    static Lead lead;
    static Event accEvent;
    static Event leadEvent;
   
    /**
     * Preparing test data
     * An account and a lead with a last future activity set 5 days in the past
     * An Event which takes place 2 days after the last future activity  
     */ 
    private static void prepare() {
        //Create a test Account
        acc = new Account(
            Name = 'test',
            Phone = '+493456',
            Fax = '+49'
            //Mobiltelefon__c = '+49'
        );
        insert acc;
        
        AssertAccount(acc.id, 0, null, true);
        AssertAccount(acc.id, 0, null, false);
        
        //Create Event on Account 5 Days in past
        accEvent = AddEvent(acc.id, -5, true);

        AssertAccount(acc.id, 5, accEvent, true);
        AssertAccount(acc.id, 0, null, false);
        
        
        //Create a test Lead
        lead = new Lead(
            LastName = 'testLead',
            Company = 'testcompany',
            Status = 'TestStatus',
            PostalCode = '72365',
            Phone = '+49123456',
            Fax = '+49'
            //Mobiltelefon__c = '+49'
        );
        insert lead;
        
        AssertLead(lead.id, 0, null, true);
        AssertLead(lead.id, 0, null, false);
        
        //Create Event on Lead 5 Days in past
        leadEvent = AddEvent(lead.id, -5, false);
        
        AssertLead(lead.id, 5, leadEvent, true);
        AssertLead(lead.id, 0, null, false);
    }
    
    /**
     * Test inserting events
     */
    private static TestMethod void testEventInsert() {
        Test.startTest();
        prepare();
        Event event2;
        //Account test
        acc.Last_Activity_Date_Future__c = Date.today().addDays(-4);
        update acc;
        event2 = AddEvent(acc.id, -2, true);
                
        // Assert last activity field is updated
        acc = [SELECT Id, Last_Activity_Past__c, Last_Activity_Date_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c FROM Account WHERE id = :acc.id];
        
        System.assertEquals(event2.id, acc.Last_Activity_ID_Past__c);
        System.assertEquals(event2.ActivityDate, acc.Last_Activity_Date_Past__c);
        System.assertEquals(null, acc.Last_Activity_Date_Future__c);
        System.assertEquals(2, acc.Last_Activity_Past__c);
        
        //Lead test  
        lead.Last_Activity_Date_Future__c = Date.today().addDays(-4);
        update lead;   
        event2 = AddEvent(lead.id, -2, false);
        
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Past__c, Last_Activity_Date_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c FROM Lead WHERE id = :lead.id];
        
        System.assertEquals(event2.id, lead.Last_Activity_ID_Past__c);
        System.assertEquals(event2.ActivityDate, lead.Last_Activity_Date_Past__c);
        System.assertEquals(null, lead.Last_Activity_Date_Future__c);
        System.assertEquals(2, lead.Last_Activity_Past__c);
        
        Test.stopTest();
    }

    /**
     * Test Updating Events
     */
    private static TestMethod void testEventUpdate() {
        Test.startTest();
        prepare();
        
        //Account test        
        accEvent.StartDateTime = Date.today().addDays(-2);
        accEvent.EndDateTime = Date.today().addDays(-2);
        accEvent.ActivityDate = Date.today().addDays(-2);
        update accEvent;
        
        AssertAccount(acc.id, 2, accEvent, true);
        
        accEvent.StartDateTime = Date.today().addDays(8);
        accEvent.EndDateTime = Date.today().addDays(8);
        accEvent.ActivityDate = Date.today().addDays(8);
        update accEvent;
        
        AssertAccount(acc.id, 0, null, true);
        AssertAccount(acc.id, -8, accEvent, false);
                
        //Lead test
        
        leadEvent.StartDateTime = Date.today().addDays(-2);
        leadEvent.EndDateTime = Date.today().addDays(-2);
        leadEvent.ActivityDate = Date.today().addDays(-2);
        update leadEvent;
        
        AssertLead(lead.id, 2, leadEvent, true);
        
        leadEvent.StartDateTime = Date.today().addDays(8);
        leadEvent.EndDateTime = Date.today().addDays(8);
        leadEvent.ActivityDate = Date.today().addDays(8);
        update leadEvent;
        
        AssertLead(lead.id, 0, null, true);
        AssertLead(lead.id, -8, leadEvent, false);
        Test.stopTest();
    }
    
    /**
     * Test deleting Event
     */
    private static TestMethod void testEventDelete() {
        Test.startTest();
        prepare();

        //Account test        
        delete accEvent;
        AssertAccount(acc.id, 0, null, true);
        
        Event event2 = AddEvent(acc.id, 2, true);        
        delete event2;        
        AssertAccount(acc.id, 0, null, false);
        
        
        //Lead test
        delete leadEvent;        
        AssertLead(lead.id, 0, null, true);
        
        event2 = AddEvent(lead.id, 2, false);                        
        delete event2;
        AssertLead(lead.id, 0, null, false);
        
        Test.stopTest();
    }
        
    private static Event AddEvent(Id recordId, Integer offset, Boolean isAccount) {
    	Event newEvent = new Event(
            Subject = 'Meet',
            StartDateTime = DateTime.now().addDays(offset),
            EndDateTime = DateTime.now().addDays(offset),
            ActivityDate = Date.today().addDays(offset)
        );
        if(isAccount)
        	newEvent.WhatId = recordId;
        else
        	newEvent.WhoId = recordId;
        insert newEvent;
        return newEvent;
    }

	private static void AssertAccount(Id recordId, Integer offset, Event checkEvent, Boolean checkPast) {
		Account checkAccount = [SELECT Id, Last_Activity_Past__c, Last_Activity_Date_Past__c, Last_Activity_ID_Past__c, Last_Activity_Future__c, Last_Activity_Date_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :recordId];
        
        String checkTime = checkPast ? 'Past' : 'Future';
        
        if(checkEvent != null) {
	        System.assertEquals(checkEvent.id, (Id)checkAccount.get('Last_Activity_ID_' + checkTime + '__c'));
	        System.assertEquals(checkEvent.ActivityDate, (Date)checkAccount.get('Last_Activity_Date_' + checkTime + '__c'));
	        System.assertEquals(offset, Integer.valueOf(checkAccount.get('Last_Activity_' + checkTime + '__c')));
        } else {
	        System.assertEquals(null, (Id)checkAccount.get('Last_Activity_ID_' + checkTime + '__c'));
	        System.assertEquals(null, (Date)checkAccount.get('Last_Activity_Date_' + checkTime + '__c'));
	        System.assertEquals(null, Integer.valueOf(checkAccount.get('Last_Activity_' + checkTime + '__c')));
        }        
	}
	
	private static void AssertLead(Id recordId, Integer offset, Event checkEvent, Boolean checkPast) {
		Lead checkLead = [SELECT Id, Last_Activity_Past__c, Last_Activity_Date_Past__c, Last_Activity_ID_Past__c, Last_Activity_Future__c, Last_Activity_Date_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :recordId];
        
        String checkTime = checkPast ? 'Past' : 'Future';
        
        if(checkEvent != null) {
	        System.assertEquals(checkEvent.id, (Id)checkLead.get('Last_Activity_ID_' + checkTime + '__c'));
	        System.assertEquals(checkEvent.ActivityDate, (Date)checkLead.get('Last_Activity_Date_' + checkTime + '__c'));
	        System.assertEquals(offset, Integer.valueOf(checkLead.get('Last_Activity_' + checkTime + '__c')));
        } else {
	        System.assertEquals(null, (Id)checkLead.get('Last_Activity_ID_' + checkTime + '__c'));
	        System.assertEquals(null, (Date)checkLead.get('Last_Activity_Date_' + checkTime + '__c'));
	        System.assertEquals(null, Integer.valueOf(checkLead.get('Last_Activity_' + checkTime + '__c')));
        }        
	}
}