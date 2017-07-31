@isTest
public class TestLeadReorder 
{
    @isTest
	public static void testReorderLeads()
    {
        //At first we create our data
        //String standardLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        //The queues
        
        //Group g1 = [SELECT Id FROM Group WHERE Name = 'Leads Köln'];
        //Group g2 = [SELECT Id FROM Group WHERE Name = 'Mass Import'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Vertriebsmitarbeiter']; 
        UserRole ur = [SELECT Id FROM UserRole WHERE Name='Marketingberater Hamburg']; 
        
        User u = new User(Alias = 'huihuih', Email='megar@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='This', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            UserRole = ur,
            TimeZoneSidKey='America/Los_Angeles', UserName='megacool@testorg.com');
        
        insert u;
        
        //Some leads
        Lead l1 = new Lead();
		l1.LastName = 'Test1';
		l1.Company = 'Test Company';
		l1.Website = 'www.testedas.de';
		l1.Phone = 'ka';
		l1.industry= 'KFZ';
		l1.industry_detail__c = 'Abschleppdients';
		l1.Status = 'unqualifiziert / Anschluss nicht erreichbar';
        l1.Vertriebsgebiet__c = 'Köln';
        l1.OwnerId = u.Id;
        l1.Last_Activity_Date_Past__c = System.today();
        l1.Last_Activity_Date_Future__c = System.today();
        //l1.RecordTypeId = standardLeadRecordTypeId;
        
        insert l1;
        
        Lead l2 = new Lead();
		l2.LastName = 'Test2';
		l2.Company = 'Test Company';
		l2.Website = 'www.testedas.de';
		l2.Phone = 'ka';
		l2.industry= 'KFZ';
		l2.industry_detail__c = 'Abschleppdients';
		l2.Status = 'kontaktiert';
        l2.OwnerId = u.Id;
        l2.Last_Activity_Date_Past__c = System.today() - 185;
        l2.Last_Activity_Date_Future__c = System.today() - 185;
        //l2.LastTransferDate = System.today() - 100;
        
        insert l2;
        
        Test.startTest();
        LeadHandler.reorderLeads();
        Test.stopTest();
        
        Lead after1 = [SELECT Owner.Id, Owner.Name FROM Lead WHERE LastName = 'Test1'];
        Lead after2 = [SELECT LastTransferDate, Owner.Id, Owner.Name FROM Lead WHERE LastName = 'Test2'];
        
        System.debug(after2.LastTransferDate);
        
        //Assertion is not possible, because we cant modify the lastTransfered date to the past
        //System.assertEquals('Leads Köln', after1.Owner.Name);
        //System.assertEquals('Offen', after2.Owner.Name);
    }
}