@isTest
public class Test_MyCustomLookupController {

    @isTest
    static void Test_MyCustomLookupController_Method() {
         
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        RecordType rt = [select id, Name from RecordType where SobjectType='Account' and Name='Kunde' Limit 1];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = 'ka';
        acc.Website = 'www.test-account.com';
        acc.Industry = 'Beratung';
        acc.industry_detail__c = 'Berufsberatung';
        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Müller';
        con.Phone = 'ka';
        con.Email = 'max.mueller@gmail.com';
        con.AccountId = acc.Id;
        
        insert con;
            
        MyCustomLookupController customLookup = new MyCustomLookupController();
        //customLookup.MyCustomLookupController();
        
        Test.stopTest();
    }
}