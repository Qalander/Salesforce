@isTest
public class Test_BatchLeadConverterUpdate {

   @isTest
   public static void BatchLeadConverterUpdate_Method() { 
       
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
            insert u;
       
       RecordType rtypes = [SELECT Name, Id FROM RecordType WHERE sObjectType = 'Lead' AND isActive = TRUE AND RecordType.Name = 'TeleSales'];   
       
       Lead l = new Lead();
       l.FirstName = 'Test Lead';
       l.LastName = 'Testi';
       l.Company = 'Test Lead Company';
       l.Website = 'www.testlead.com';
       l.Phone = 'ka';
	   l.Industry = 'Beratung';   
       l.industry_detail__c = 'Berufsberatung';
       //l.Status = 'Offen';
       l.Status = 'kein verkaufbares Produkt';
       l.LeadSource = 'Adwords Telesales';
       l.RecordTypeId = rtypes.Id;
       l.Produktauswahl__c = '';
       l.Previous_User__c = u.Id;
       l.IsConverted = false;
       
       insert l;
       
       
       l.Produktauswahl__c = 'Kostenloses Produkt';
       
       update l;
       
       BatchLeadConverterUpdate blcu = new BatchLeadConverterUpdate();
       Test.startTest();
       //Id batchid = Database.executeBatch(blcu);
       Database.executeBatch(blcu, 2);
       Test.stopTest();       
    
 /*
       System.assertEquals(l.IsConverted, TRUE);
       System.assertEquals(l.ConvertedAccountId, NULL);
       System.assertEquals(l.ConvertedContactId, NULL);
       System.assertEquals(l.ConvertedOpportunityId, NULL);

*/
       
   }
}