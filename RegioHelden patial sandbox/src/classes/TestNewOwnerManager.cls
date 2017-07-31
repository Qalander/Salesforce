@isTest
public class TestNewOwnerManager {

    @isTest
    public static void newOwnerManager()
    {
        
        Test.startTest();
	
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        list<Account> objectlist = new list<Account>();
        
        
        
        Test.stopTest();
		
    }
    
}