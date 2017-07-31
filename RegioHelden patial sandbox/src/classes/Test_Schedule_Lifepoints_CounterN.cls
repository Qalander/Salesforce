@isTest
public class Test_Schedule_Lifepoints_CounterN {

    @isTest//(SeeAllData=true)
    static void Test_ScheduleN2(){ 

        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
            insert u;
        
			//RecordType rt = [select id, Name from RecordType where SobjectType='Account' and Name='Kunde' Limit 1];
        	
        	Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
            Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
            Id rtId = AccountRecordTypeInfo.get('Kunde').getRecordTypeId();
		
        
        	Account acc = new Account();
            acc.Health__c = 100;
            acc.Phone = 'ka';
            acc.Name = 'Garant Immobilien Holding GmbH 1';
            acc.Industry = 'KFZ';
        	acc.Website = 'www.test.com';
        	acc.industry_detail__c = 'KFZ Gutachter';
        	//acc.RecordType.Name = rt.Name;
        	acc.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc.OwnerId = u.Id;
        
            insert acc;
 			
        	Contract__c contr = new Contract__c();
            contr.Name = 'contr';
            contr.Account__c = Acc.Id;
            contr.product_id__c = '6542';
            contr.started_date__c = date.today()-31;
        	contr.Status__c = '1';
        	contr.Customer__c = acc.Id;
        
            insert contr; 
        
        	Contract__c contr2 = new Contract__c();
            contr2.Name = 'contr2';
            contr2.Account__c = Acc.Id;
            contr2.product_id__c = '6547';
            contr2.started_date__c = date.today()-29;
        	contr2.Status__c = '1';
        	contr2.Customer__c = acc.Id;
        
            insert contr2; 
        	
            Account acc2 = new Account();
            acc2.Health__c = 100;
            acc2.Phone = 'ka';
            acc2.Name = 'Garant Immobilien Holding GmbH';
            acc2.Industry = 'KFZa';
        	acc2.Website = 'www.teast.com';
        	acc2.industry_detail__c = 'KFZ Gutachter';
        	acc2.AdwordsContract__c = contr.Id;
        	acc2.recordtypeid = AccountRecordTypeInfo.get('Kunde').getRecordTypeId();
        	acc2.OwnerId = u.Id;
        	acc2.Vertriebsgebiet__c = 'Leipzig';
        	acc2.LastClosedTask__c = date.today();
        	acc2.Projektmanager__c = u.Id;
        	acc2.Key_Account__c = 'Key Account';
        	//acc2.AdWords_Start_Date__c = date.today()+270;
        	//acc2.StatusAdwords__c = contr.Status__c;
        	acc2.HeroCentralId__c = contr.product_id__c;
        	
            insert acc2;
        
        	Account testAccAfterInsert = [SELECT Id, LastClosedTask__c, AdWords_Start_Date__c, SEO_Start_Date__c, Customer_Status__c, LP_Start_Date__c, CustomerStateAdwords__c, CustomerStateSeo__c, StatusSeo__c, StatusAdwords__c FROM Account WHERE Id =:acc2.Id];
        
        	//System.assert(testAccAfterInsert.size() > 0);
        	
        	update acc2;
        
        	system.debug('LastClosedTask__c: ' + testAccAfterInsert.LastClosedTask__c);
        	system.debug('AdWords_Start_Date__c: ' + testAccAfterInsert.AdWords_Start_Date__c);
        	system.debug('SEO_Start_Date__c: ' + testAccAfterInsert.SEO_Start_Date__c);
        	system.debug('Customer_Status__c: ' + testAccAfterInsert.Customer_Status__c);
        	system.debug('LP_Start_Date__c: ' + testAccAfterInsert.LP_Start_Date__c);
        	system.debug('CustomerStateAdwords__c: ' + testAccAfterInsert.CustomerStateAdwords__c);
        	system.debug('CustomerStateSeo__c: ' + testAccAfterInsert.CustomerStateSeo__c);
        	system.debug('StatusSeo__c: ' + testAccAfterInsert.StatusSeo__c);
        	system.debug('StatusAdwords__c: ' + testAccAfterInsert.StatusAdwords__c);
        
			//acc2.CustomerStateAdwords__c = contr.Status__c;        
        
        	Account acc3 = new Account();
            acc3.Health__c = 40;
            acc3.Phone = 'ka';
            acc3.Name = 'Garant Immobilien Holding GmbH';
            acc3.Industry = 'KFZ';
        	acc3.Website = 'www.test.com';
        	acc3.industry_detail__c = 'KFZ Gutachter';
        	acc3.SEOContract__c = contr.Id;
        	acc3.Key_Account__c = 'Key Account';
        	acc3.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc3.OwnerId = u.Id;
        	acc3.HeroCentralId__c = contr.product_id__c;
        	acc3.AdwordsContract__c = contr.Id;
        
        	insert acc3;
        
        	Account acc5 = new Account();
            acc5.Health__c = 20;
            acc5.Phone = 'ka';
            acc5.Name = 'Garant Immobilien Holding GmbH';
            acc5.Industry = 'KFZ';
        	acc5.Website = 'www.test.com';
        	acc5.industry_detail__c = 'KFZ Gutachter';
        	acc5.SEOContract__c = contr2.Id;
        	acc5.Key_Account__c = 'Key Account';
        	acc5.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc5.OwnerId = u.Id;
        	acc5.HeroCentralId__c = contr2.product_id__c;
        	acc5.AdwordsContract__c = contr2.Id;
        
        	insert acc5;
        
        	Account acc4 = new Account();
            acc4.Health__c = 0;
            acc4.Phone = 'ka';
            acc4.Name = 'Garant Immobilien Holding GmbH ';
            acc4.Industry = 'KFZ';
        	acc4.Website = 'www.test.com';
        	acc4.industry_detail__c = 'KFZ Gutachter';
        	acc4.SEOContract__c = contr.Id;
        	acc4.Key_Account__c = 'Key Account';
        	acc4.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc4.OwnerId = u.Id;
        	acc4.HeroCentralId__c = contr.product_id__c;

        	insert acc4;
 
        	case newCase = new case();
            newCase.AccountId = acc3.Id;
            newCase.Origin = 'Outbound Call';
            newCase.Status = 'Offen';
            newCase.Reason = '5';
			newCase.Service_Fall__c = 'Kundenbriefing durchführen';
            newCase.CreatedFromBatch__c = true;
            newCase.Subject = 'Account kontaktieren - Zeit abgelaufen';
        
        	insert newCase;
        
            Case cs = new Case();
            cs.OwnerId = u.Id;
            cs.Status = 'Offen';
            cs.Origin = 'Outbound - Call';
            cs.Reason = '5';
            cs.Subject = 'Test';
            cs.Service_Fall__c = 'Kundenbriefing durchführen';
            cs.AccountId = acc3.Id;
            cs.CreatedFromBatch__c = true;
        	cs.Call_To_Action__c = cs.OwnerId;
            //cs.isClosed = false;
            insert cs;
        
        	Case cs2 = new Case();
            cs2.OwnerId = u.Id;
            cs2.Status = 'Offen';
            cs2.Origin = 'Outbound - Call';
            cs2.Reason = '5';
            cs2.Subject = 'Test';
            cs2.Service_Fall__c = 'Kundenbriefing durchführen';
            cs2.AccountId = acc4.Id;
            cs2.CreatedFromBatch__c = true;
        	cs2.Call_To_Action__c = cs2.OwnerId;
        	//cs2.IsClosed = false;
        
            insert cs2;
        
        	Case cs3 = new Case();
            cs3.OwnerId = u.Id;
            cs3.Status = 'Offen';
            cs3.Origin = 'Inbound - Mail';
            cs3.Subject = 'Test';
            cs3.Reason = '5';
			cs3.Service_Fall__c = 'Kundenbriefing durchführen';
            cs3.AccountId = acc3.Id;
            cs3.CreatedFromBatch__c = true;
        	cs3.Call_To_Action__c = cs2.OwnerId;
        
            insert cs3;

                        
        	cs3.origin= 'Inbound - Mail';
        	cs3.Status = 'Geschlossen - gelöst';
        
        	update cs3;

       		

    		Test.StartTest();
            
                 LifepointsCounterN btc = new LifepointsCounterN();
                 ID batchprocessid = Database.executeBatch(btc);
        	
        	Test.stopTest();
        
    	}
        
        static testMethod void Test_ScheduleN3(){
            
        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
            insert u;
        
			//RecordType rt = [select id, Name from RecordType where SobjectType='Account' and Name='Kunde' Limit 1];
        	
        	Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
            Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
            Id rtId = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
		
        
        	Account acc = new Account();
            acc.Health__c = 100;
            acc.Phone = 'ka';
            acc.Name = 'Test';
            acc.Industry = 'KFZ';
        	acc.Website = 'www.test.com';
        	acc.industry_detail__c = 'KFZ Gutachter';
        	//acc.RecordType.Name = rt.Name;
        	acc.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc.OwnerId = u.Id;
        
            insert acc;
 			
        	Contract__c contr = new Contract__c();
            contr.Name = 'test2';
            contr.Account__c = Acc.Id;
            contr.product_id__c = '6542';
            contr.started_date__c = date.today()+270;
        	contr.Status__c = '1';
        	contr.Customer__c = acc.Id;
        
            insert contr; 
        
            Account acc2 = new Account();
            acc2.Health__c = 100;
            acc2.Phone = 'ka';
            acc2.Name = 'Testa';
            acc2.Industry = 'KFZa';
        	acc2.Website = 'www.teast.com';
        	acc2.industry_detail__c = 'KFZ Gutachter';
        	acc2.AdwordsContract__c = contr.Id;
        	acc2.recordtypeid = AccountRecordTypeInfo.get('Kunde').getRecordTypeId();
        	acc2.OwnerId = u.Id;
        	acc2.Vertriebsgebiet__c = 'Leipzig';
        	acc2.LastClosedTask__c = date.today();
        	acc2.Projektmanager__c = u.Id;
        	acc2.Key_Account__c = 'Key Account';
        	//acc2.AdWords_Start_Date__c = date.today()+270;
        	//acc2.StatusAdwords__c = contr.Status__c;
        	acc2.HeroCentralId__c = contr.product_id__c;
        	
            insert acc2;
        
        	Account testAccAfterInsert = [SELECT Id, LastClosedTask__c, AdWords_Start_Date__c, SEO_Start_Date__c, Customer_Status__c, LP_Start_Date__c, CustomerStateAdwords__c, CustomerStateSeo__c, StatusSeo__c, StatusAdwords__c FROM Account WHERE Id =:acc2.Id];
        
        	//System.assert(testAccAfterInsert.size() > 0);
        	
        	update acc2;
        
        	system.debug('LastClosedTask__c: ' + testAccAfterInsert.LastClosedTask__c);
        	system.debug('AdWords_Start_Date__c: ' + testAccAfterInsert.AdWords_Start_Date__c);
        	system.debug('SEO_Start_Date__c: ' + testAccAfterInsert.SEO_Start_Date__c);
        	system.debug('Customer_Status__c: ' + testAccAfterInsert.Customer_Status__c);
        	system.debug('LP_Start_Date__c: ' + testAccAfterInsert.LP_Start_Date__c);
        	system.debug('CustomerStateAdwords__c: ' + testAccAfterInsert.CustomerStateAdwords__c);
        	system.debug('CustomerStateSeo__c: ' + testAccAfterInsert.CustomerStateSeo__c);
        	system.debug('StatusSeo__c: ' + testAccAfterInsert.StatusSeo__c);
        	system.debug('StatusAdwords__c: ' + testAccAfterInsert.StatusAdwords__c);
        
			//acc2.CustomerStateAdwords__c = contr.Status__c;        
        
        	Account acc3 = new Account();
            acc3.Health__c = 40;
            acc3.Phone = 'ka';
            acc3.Name = 'Test';
            acc3.Industry = 'KFZ';
        	acc3.Website = 'www.test.com';
        	acc3.industry_detail__c = 'KFZ Gutachter';
        	acc3.SEOContract__c = contr.Id;
        	acc3.Key_Account__c = 'Key Account';
        	acc3.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc3.OwnerId = u.Id;
        	acc3.HeroCentralId__c = contr.product_id__c;
        
        	insert acc3;
        
        	Account acc4 = new Account();
            acc4.Health__c = 0;
            acc4.Phone = 'ka';
            acc4.Name = 'Garant Immobilien Holding GmbH';
            acc4.Industry = 'KFZ';
        	acc4.Website = 'www.test.com';
        	acc4.industry_detail__c = 'KFZ Gutachter';
        	acc4.SEOContract__c = contr.Id;
        	acc4.Key_Account__c = 'Key Account';
        	acc4.recordtypeid = AccountRecordTypeInfo .get('Kunde').getRecordTypeId();
        	acc4.OwnerId = u.Id;
        	acc4.HeroCentralId__c = contr.product_id__c;

        	insert acc4;
 
        	case newCase = new case();
            newCase.AccountId = acc3.Id;
            newCase.Origin = 'Outbound Call';
            newCase.Status = 'Offen';
            newCase.Reason = '5';
			newCase.Service_Fall__c = 'Kundenbriefing durchführen';
            newCase.CreatedFromBatch__c = true;
            newCase.Subject = 'Account kontaktieren - Zeit abgelaufen';
        
        	insert newCase;
        
            Case cs = new Case();
            cs.OwnerId = u.Id;
            cs.Status = 'Offen';
            cs.Origin = 'Outbound - Call';
            cs.Reason = '5';
            cs.Subject = 'Test';
            cs.Service_Fall__c = 'Kundenbriefing durchführen';
            cs.AccountId = acc3.Id;
            cs.CreatedFromBatch__c = true;
        	cs.Call_To_Action__c = cs.OwnerId;
            
            insert cs;
        
        	Case cs2 = new Case();
            cs2.OwnerId = u.Id;
            cs2.Status = 'Offen';
            cs2.Origin = 'Outbound - Call';
            cs2.Reason = '5';
            cs2.Subject = 'Rechnung nicht erhalten';
            cs2.Service_Fall__c = 'Kundenbriefing durchführen';
            cs2.AccountId = acc4.Id;
            cs2.CreatedFromBatch__c = true;
        	cs2.Call_To_Action__c = cs2.OwnerId;
        	//cs2.IsClosed = false;
        
            insert cs2;
        
        	Case cs3 = new Case();
            cs3.OwnerId = u.Id;
            cs3.Status = 'Offen';
            cs3.Origin = 'Inbound - Mail';
            cs3.Subject = 'Rechnung nicht erhalten';
            cs3.Reason = '5';
			cs3.Service_Fall__c = 'Kundenbriefing durchführen';
            cs3.AccountId = acc3.Id;
            cs3.CreatedFromBatch__c = true;
        	cs3.Call_To_Action__c = cs2.OwnerId;
        
            insert cs3;

                        
        	cs3.origin= 'Inbound - Mail';
        	cs3.Status = 'Geschlossen - gelöst';
        
        	update cs3;
    
    		Test.StartTest();
            Schedule_Lifepoints_CounterBatchN.scheduleMe();
        	Test.stopTest();
        }  
}