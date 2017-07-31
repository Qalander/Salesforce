@isTest
public class Test_CustomAccountLookupController {

    @isTest
    public static void Test_CustomAccountLookupController() {
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        RecordType rt = [select id, Name from RecordType where SobjectType='Account' and Name='Kunde' Limit 1];
        
        Account acc = new Account();
        acc.Name = 'Test asrhtgfd';
        acc.Phone = 'ka';
        acc.Website = 'www.testddsf.com';
        acc.Industry = 'Beratung';
        acc.industry_detail__c = 'Steuerberatung';
        
        insert acc;
      
        Account acc2 = new Account();
        acc2.Phone = 'ka';
        //Test.setCurrentPageReference(new PageReference('Page'))
        
        CustomAccountLookupController calc = new CustomAccountLookupController();
        calc.search();
        calc.saveAccount();
        calc.getFormTag();
        
        Test.stopTest();
        
    }
    
}