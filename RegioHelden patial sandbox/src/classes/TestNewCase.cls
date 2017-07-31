@isTest
public class TestNewCase {
	
    @isTest
    public static void newEmailCase()
    {
        Test.startTest();
        Case c1 = new Case(Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschicken');
        insert c1;
        
        Case c2 = new Case(Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschicken', Description='Wir würden gerne den Content der Webseite abändern');
        insert c2;
        
        Case c3 = new Case(Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschicken', Description='Können Sie bitte die Anrufe an mich weiterleiten? Das grenzt fast an Abzocke');
        insert c3;
        
        Case newCase1 = [SELECT Reason, Service_Fall__c, Beschwerde__c FROM Case WHERE Id =: c1.Id];
        Case newCase2 = [SELECT Reason, Service_Fall__c, Beschwerde__c FROM Case WHERE Id =: c2.Id];
        Case newCase3 = [SELECT Reason, Service_Fall__c, Beschwerde__c FROM Case WHERE Id =: c3.Id];
        
        /*System.assertEquals('Rechnung', newCase1.Reason);
        System.assertEquals('Rechnung nicht erhalten', newCase1.Service_Fall__c);
        System.assertEquals(false, newCase1.Beschwerde__c);
        System.assertEquals('Feedback während der Konzeption', newCase2.Reason);
        System.assertEquals('Feedback zu Webseite', newCase2.Service_Fall__c);
        System.assertEquals('Anrufmessung', newCase3.Reason);
        System.assertEquals('Weiterleitungsziel ändern', newCase3.Service_Fall__c);
        System.assertEquals(true, newCase3.Beschwerde__c);*/
        Test.stopTest();    
    }
   
    @isTest
    public static void newEmailToCase()
    {
        
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        RecordType rt = [select id, Name from RecordType where SobjectType='Account' and Name='Interessent' Limit 1];
        
        Account acc1 = new Account(Name='TESTaaaaaaaaa', Email__c = 'AAdaniel.hankammer@ilume.de', 
                                   	Projektmanager__c = u.Id, Phone = '+493022354125', BypassValidation__c = TRUE, 
                                   	Industry = 'Baugewerbe', industry_detail__c = 'Arbeitsbühne');
        //acc1.Projektmanager__c = u;
        System.debug('****** = ' +acc1.BypassValidation__c);
        insert acc1;
        
        Contact con1 = new Contact(AccountId = Acc1.Id, FirstName = 'Pippo',  LastName = 'Topolino',Email = 'AAdaniel.hankammer@ilume.de', Phone = '+493022354125', MobilePhone = '+491514785112');
        insert con1;
        
        Case c4 = new Case(Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschickenA', SuppliedEmail = 'AAdaniel.hankammer@ilume.de');
        insert c4;
        Case c5 = new Case(Status = 'Offen', Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschickenA', SuppliedEmail = 'AAdaniel.hankammer@ilume.de');
        insert c5;
        c5.Status = 'Wartet auf Antwort des Kunden';
        update c5;
        
        Case c6 = new Case(Status = 'Offen', Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschickenB', SuppliedEmail = 'AAdaniel.hankammer@ilume.de');
        insert c6;
        c6.Status = 'Wartet auf Antwort des Kunden';
        update c6;
        
        Case c7 = new Case(Status = 'Offen', Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschickenC', SuppliedEmail = 'AAdaniel.hankammer@ilume.de');
        insert c7;
        c7.Status = 'Wartet auf Antwort des Kunden';
        update c7;
        
        Case c8 = new Case(Status = 'Offen', Origin = 'Inbound - Mail', Subject = 'Können Sie mir eine Rechnung zuschickenD', SuppliedEmail = 'AAdaniel.hankammer@ilume.de');
        insert c8;
        c8.Status = 'Wartet auf Antwort des Kunden';
        update c8;
        
        
        
        Test.stopTest();
    }
    
}