@isTest
public class TestUserController 
{
	
    @isTest
    public static void testUserController()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserregioh@testorg.com');
        
        insert u;
        
        System.runAs(u)
        {
            Test.startTest();
            PageReference pageRef = Page.UpdateUserFields;
            Test.setCurrentPage(pageRef);
    
            UserController controller = new UserController();
            
            controller.save();
            Test.stopTest();
        }
    }
}