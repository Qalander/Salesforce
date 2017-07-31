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
private class TestEventTrigger {

    static Account acc;
    static Lead lead;
    static Event event1;
    static User user;
   
    /**
     * Preparing test data
     */ 
    private static void prepare() {
    	user = new User();
		user.LastName = 'Test Code';
		user.Email = 'test@test.com';
		user.Alias = 'Tcode';
		user.Username = 'D4s1st31nUs3r@test.com';
		user.CommunityNickname = 'test12';
		user.LocaleSidKey = 'en_US';
		user.TimeZoneSidKey = 'GMT';
		user.ProfileID = '00e200000011akG';
		user.LanguageLocaleKey = 'en_US';
		user.EmailEncodingKey = 'UTF-8';
		insert user;
		
        acc = new Account(Name = 'test', Phone = '+493456', Fax = '+49', OwnerId = user.Id);
        insert acc;
        lead = new Lead(LastName = 'testLead', Company = 'testcompany', Status = 'TestStatus', PostalCode = '72365', Phone = '+49123456', Fax = '+49', OwnerId = user.Id);
        insert lead;
        event1 = new Event(WhatId = acc.id,  Subject = 'Call', StartDateTime = DateTime.now().addDays(3), EndDateTime = DateTime.now().addDays(3), ActivityDate = Date.today().addDays(3), OwnerId = user.Id);
        insert event1;
        event1 = new Event(WhoId = lead.id,  Subject = 'Call', StartDateTime = DateTime.now().addDays(-8), EndDateTime = DateTime.now().addDays(-8), ActivityDate = Date.today().addDays(-8), OwnerId = user.Id);
        insert event1;
    }
    
    /**
     * Test inserting events
     */
    private static TestMethod void testEventinsert() {
        prepare();
        Event event2 = new Event(WhatId = acc.id, Subject = 'Call', StartDateTime = DateTime.now().addDays(-2), EndDateTime = DateTime.now().addDays(-2), ActivityDate = Date.today().addDays(-2), OwnerId = user.Id);
        system.runAs(user){
        	insert event2;
        }
        // Assert last activity field is updated
        acc = [SELECT Id, Last_Activity_Owner_Past__c, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE id = :acc.id];
        System.assertEquals(2.0, acc.Last_Activity_Past__c);
        System.assertEquals(user.Id, acc.Last_Activity_Owner_Past__c);
        System.assertEquals(acc.Last_Activity_Date_Past__c, event2.ActivityDate);
        System.assertEquals(acc.Last_Activity_ID_Past__c, event2.id);
        
        
        event2 = new Event(WhoId = lead.id,  Subject = 'Call', StartDateTime = DateTime.now().addDays(-2), EndDateTime = DateTime.now().addDays(-2), ActivityDate = Date.today().addDays(-2), OwnerId = user.Id);
        system.runAs(user){
        	insert event2;
        }
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Owner_Past__c, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(2, lead.Last_Activity_Past__c);
        System.assertEquals(user.Id, lead.Last_Activity_Owner_Past__c);
        System.assertEquals(lead.Last_Activity_Date_Past__c, event2.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, event2.id);
    }
    
    /**
     * Test Updating Events
     */
    private static TestMethod void testeEventUpdate() {
        prepare();
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, 8);
        System.assertEquals(lead.Last_Activity_Date_Past__c, event1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, event1.id);
        
        event1.StartDateTime = DateTime.now().addDays(1);
        event1.EndDateTime = DateTime.now().addDays(2);
        event1.ActivityDate = Date.today().addDays(1);
        system.runAs(user){
        	update event1;
        }
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Future__c, -1);
        System.assertEquals(lead.Last_Activity_Date_Future__c, event1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Future__c, event1.id);
        
    }
    
    /**
     * Test deleting Event
     */
    private static TestMethod void testEventDelete() {
        prepare();
        // Assert Setup is correct
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, 8);
        System.assertEquals(lead.Last_Activity_Date_Past__c, event1.ActivityDate);
        System.assertEquals(lead.Last_Activity_ID_Past__c, event1.id);
        
        system.runAs(user){
        	delete event1;
        }
        // Assert last activity field is updated
        lead = [SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE id = :lead.id];
        System.assertEquals(lead.Last_Activity_Past__c, null);
        System.assertEquals(lead.Last_Activity_Date_Past__c, null);
        System.assertEquals(lead.Last_Activity_ID_Past__c, null);
    }
}