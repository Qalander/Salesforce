@isTest
public class TestNewContract {

    @isTest
    public static void newContract()
    {
        
        Test.startTest();
	
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        Account acc1 = new Account(Name='TESTaaaaaaaaa', Email__c = 'AAdaniel.hankammer@ilume.de', 
                                   	Projektmanager__c = u.Id, Phone = '+493022354125', BypassValidation__c = TRUE, 
                                   	Industry = 'Baugewerbe', industry_detail__c = 'Arbeitsbühne');

        RecordType rt = [select id, Name from RecordType where SobjectType='Task' and Name='Kundenservice' Limit 1];
        
        Contract con1 = new Contract(AccountID = acc1.Id, Status = 'Entwurf', StartDate = Date.Today(), ContractTerm = 4);
        
        insert con1;
        
        
        
        Test.stopTest();
		
    }
    
}