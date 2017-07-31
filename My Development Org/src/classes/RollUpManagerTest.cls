@isTest
public class RollUpManagerTest {
    
    @isTest
    public static void TestManager(){
		insert new TaskRollUpSetting__c(
            Name = 'Test',
            IsActive__c = true,
            FilterCriteriaTasks__c = 'WHERE IsDeleted = false',
            FilterCriteriaEvents__c = 'WHERE IsDeleted = false',
            ByOwner__c = false,
            RollUpField__c = 'LastNetCall__c',
            Prefix__c = '003',
            Sobject__c = 'Contact' );
        
       	Account acc = new Account(Name = 'test 123', Phone = '+491234435');
        insert acc;       

        List<Contact> contactList = new List<Contact>();
        for (integer x = 0; x <= 10; x++){
        	contactList.add(new Contact(LastName = 'Mustermann', AccountId = acc.Id, Phone = 'ka')); 
        }
        insert contactList;
        
        List<Task> tskList = new List<Task>();
        for (integer i = 0; i <= 10; i++){
            tskList.add(new Task(
            ActivityDate = Date.today() + i,
            Subject = 'Test',
            WhoId = contactList[i].Id));
        }        
        insert tskList;
        
        Event objEvent = new Event();
        objEvent.WhatID = acc.Id;
        objEvent.DurationInMinutes = 15;
        objEvent.ActivityDateTime = Datetime.now();
        objEvent.WhoId = contactList[0].Id;
        insert objEvent;
        
        Test.startTest();
        	RollUpManager.StartBatch('Select Id from Contact');
        Test.stopTest();        
    }
}