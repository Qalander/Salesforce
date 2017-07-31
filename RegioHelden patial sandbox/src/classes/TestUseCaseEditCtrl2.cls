@isTest
public class TestUseCaseEditCtrl2 {
	@isTest    
    public static void TestUseCaseEditCtrl2(){

        Test.startTest();
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        	insert u; 
        
        Case c = new Case();
        c.OwnerId = u.Id;
        c.Status = 'Offen';
    	c.Origin = 'Outbound Mail';
        c.Priority = 'Normal';
        c.Reason = '5';
        c.Service_Fall__c = 'Kundenbriefing durchführen';  
        c.Beschwerde__c = false;
        c.Description = 'Test Case';
        insert c;
        System.debug('********' + c.Reason);
        System.debug('********' + c.Service_Fall__c);
        UseCaseEditCtrl2 ct = new UseCaseEditCtrl2(new ApexPages.StandardController(c));
        ct.Cancel();
        
        Test.stopTest();
    }
}