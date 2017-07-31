@isTest
public class Test_BatchVertriebsgebieteLeipzig {
	static testMethod void myUnitTest() {
     
        list<string> plz = new list<string>();
        
        Lead lead = new Lead();
        lead.LastName = 'Test Lead';
        lead.Company = 'Lead GmbH';
        lead.Website = 'www.lead-gmbh.com';
        lead.Phone = '+498578412';
        lead.Industry = 'Handel';
        lead.industry_detail__c = 'Kaufhaus';
        lead.Status = 'Offen';
        lead.LeadSource = 'anwalt.de';
        lead.Vertriebsgebiet__c = 'TeleSales/Omnea';
        lead.PostalCode = '';
        //lead.Address = 'Obernhagen 231840 Hessisch Oldendorf Großenwieden Deutschland';
        
        insert lead;
        
        lead.PostalCode = '06258';
        lead.Vertriebsgebiet__c = 'Leipzig';
        
        update lead;
        
        list<Vertriebsgebiet__c> aGebiet = new List<Vertriebsgebiet__c>();
        
        for(Integer i=0; i<10; i++) {
            Vertriebsgebiet__c vertgeb = new Vertriebsgebiet__c();
            vertgeb.PLZ__c = '06258';
            vertgeb.Name = 'Leipzig';

            aGebiet.add(vertgeb);
        }

        if(aGebiet.size() > 0){
            
            Insert aGebiet;
        }
        
        Test.StartTest();
        	BatchVertriebsgebieteLeadUpdateLeipzig btc = new BatchVertriebsgebieteLeadUpdateLeipzig();
            Database.executeBatch(btc, 1);
        Test.stopTest();
    }

}