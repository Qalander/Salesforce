@isTest
public class Test_EntitlementInsert {

    @isTest
    public static void Test_EntitlementInsert() {
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        RecordType rt = [select id, Name from RecordType where SobjectType = 'Account' and Name = 'Kunde' Limit 1];
        
        Account acc = new Account();
        acc.Name = 'Test asrhtgfd';
        acc.Phone = 'ka';
        acc.Website = 'www.testddsf.com';
        acc.Industry = 'Beratung';
        acc.industry_detail__c = 'Steuerberatung';
        acc.OwnerId = u.Id;
        
        insert acc;
     
        Case cs = new Case();
        cs.Status = 'Offen';
        cs.Origin = 'Outbound Mail';
        cs.Reason = '5';
        cs.Service_Fall__c = 'Kundenbriefing durchführen';
        //cs.OwnerId = u.Id;

        insert cs;
        
        system.debug('***************** cs.OwnerId: ' + cs.OwnerId);
        
        List<Entitlement> entls = new List<Entitlement>();
        
        /*for(integer i=1; i<=20; i++) {
            Entitlement et = new Entitlement();
            et.Name = 'Universal Entitlement';
            et.AccountId = acc.Id;
            entls.add(et);
        }*/
        
       // insert entls;
        
        Entitlement ent = new Entitlement();
        ent.Name = 'Universal Entitlement';
        ent.AccountId = acc.Id;
        insert ent;
        
        cs.description = 'AAA';
        //cs.Entitlement.Name = ent.Name;
        
        update cs;
        
        Test.stopTest();
    }
}