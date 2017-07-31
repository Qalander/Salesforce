@isTest
public class TestLeadReset {

    @isTest
    public static void testLeadReset()
    {
        //At first we create our data
        String standardLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        //The queues
        
        Group g1 = [SELECT Id FROM Group WHERE Name = 'Leads Köln'];
        Group g2 = [SELECT Id FROM Group WHERE Name = 'Mass Import'];
        
        //Some leads
        Lead l1 = new Lead();
		l1.LastName = 'Test1';
		l1.Company = 'Test Company';
		l1.Website = 'www.testedas.de';
		l1.Phone = 'ka';
		l1.industry= 'KFZ';
		l1.industry_detail__c = 'Abschleppdients';
		l1.Status = 'unqualifiziert / Anschluss nicht erreichbar';
        l1.OwnerId = g2.Id;
        l1.RecordTypeId = standardLeadRecordTypeId;
        
        insert l1;
        
        Lead l2 = new Lead();
		l2.LastName = 'Test2';
		l2.Company = 'Test Company';
		l2.Website = 'www.testedas.de';
		l2.Phone = 'ka';
		l2.industry= 'KFZ';
		l2.industry_detail__c = 'Abschleppdients';
		l2.Status = 'kontaktiert';
        l2.OwnerId = g1.Id;
        l2.Last_Activity_Date_Past__c = System.today() - 185;
        l2.Last_Activity_Date_Future__c = System.today() - 185;
        l2.RecordTypeId = standardLeadRecordTypeId;
        
        insert l2;
        
        Test.startTest();
        LeadHandler.resetLeads();
        Test.stopTest();
        
        Lead after1 = [SELECT Status FROM Lead WHERE LastName = 'Test1'];
        Lead after2 = [SELECT Status FROM Lead WHERE LastName = 'Test2'];
        
        System.assertEquals('unqualifiziert / Anschluss nicht erreichbar', after1.Status);
        System.assertEquals('Offen', after2.Status);
    }
}