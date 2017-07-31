@isTest
public class TestNewTask {

    @isTest
    public static void newTask()
    {
        
        Test.startTest();
	
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        RecordType rt = [select id, Name from RecordType where SobjectType='Task' and Name='Kundenservice' Limit 1];

        
        Event eveTest = new Event(OwnerId=u.Id, ActivityDateTime=Date.Today(),Description='Test Event',
                                  DurationInMinutes=10,Subject='Test Event');
        insert eveTest;
        
        Task tskTest = new Task(OwnerId=u.Id, ActivityDate=Date.Today(),Description='Test Task',
                                Priority='Low',Status='Completed',Subject='Test Task');
        insert tskTest;
        
        Test.stopTest();
		
    }
    
}