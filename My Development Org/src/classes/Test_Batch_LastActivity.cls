@isTest
private class Test_Batch_LastActivity {
    @isTest
    static void myUnitTest() {
       
        	Account acc2 = new Account();
            acc2.Health__c = 100;
            acc2.Phone = 'ka';
            acc2.Name = 'Testa';
            acc2.Industry = 'KFZa';
        	acc2.Website = 'www.teast.com';
            //acc2.ROL_Kunde__c = true;
        	acc2.industry_detail__c = 'KFZ Gutachter';
        	
        	
            insert acc2;
        
        	Contract__c contr = new Contract__c();
            contr.Name = 'test2';
            contr.Account__c = Acc2.Id;
            contr.product_id__c = '2131a2312312';
            contr.started_date__c = date.today()-10;
            insert contr; 
        
            Account acc = new Account();
            acc.Health__c = 100;
            acc.Phone = 'ka';
            acc.Name = 'Test';
            acc.Industry = 'KFZ';
        	acc.Website = 'www.test.com';
            //acc.ROL_Kunde__c = true;
        	acc.industry_detail__c = 'KFZ Gutachter';
        	acc.AdwordsContract__c = contr.Id;
        
        	
            insert acc;
        
        	/*Account acc3 = new Account();
            acc3.Health__c = 40;
            acc3.Phone = 'ka';
            acc3.Name = 'Test';
            acc3.Industry = 'KFZ';
        	acc3.Website = 'www.test.com';
            //acc3.ROL_Kunde__c = true;
        	acc3.industry_detail__c = 'KFZ Gutachter';
        	acc3.AdwordsContract__c = contr.Id;
        
        	insert acc3;*/

            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
            insert u;
            
            Case cs = new Case();
            cs.OwnerId = u.Id;
            cs.Status = 'Offen';
            cs.Origin = 'Outbound - Call';
            cs.Reason = '5';
        	cs.Service_Fall__c = 'Kundenbriefing durchführen';
            cs.Subject = 'Rechnung nicht erhalten';
            cs.AccountId = acc.Id;
            cs.CreatedFromBatch__c = true;
        	cs.Call_To_Action__c = cs.OwnerId;
            
            insert cs;
			system.debug('##### Case Reason: ' + cs.Reason);
        	system.debug('##### Case Service Fall: ' + cs.Service_Fall__c);

        
        	Case cs2 = new Case();
            cs2.OwnerId = u.Id;
            cs2.Status = 'Offen';
            cs2.Origin = 'Outbound - Call';
            cs2.Reason = '5';
        	cs2.Service_Fall__c = 'Kundenbriefing durchführen';
            cs2.Subject = 'Rechnung nicht erhalten';
            cs2.AccountId = acc.Id;
            cs2.CreatedFromBatch__c = true;
        	cs2.Call_To_Action__c = cs2.OwnerId;
        	cs2.ClosedDate = Date.Today()-2;
        
            insert cs2;
        
        	Case cs3 = new Case();
            cs3.OwnerId = u.Id;
            cs3.Status = 'Offen';
            cs3.Origin = 'Inbound - Mail';
        	cs3.Reason = '5';
        	cs3.Service_Fall__c = 'Kundenbriefing durchführen';
            cs3.Subject = 'Rechnung nicht erhalten';
            cs3.AccountId = acc.Id;
            cs3.CreatedFromBatch__c = true;
        	cs3.Call_To_Action__c = cs2.OwnerId;
        	cs3.ClosedDate = Date.Today();
        
            insert cs3;
        	//cs3.Origin= 'Inbound - Mail';
        	//update cs3;
    
        	cs2.Status = 'Geschlossen - gelöst';
        	
        	update cs2;
        	Task T = new Task();
    		T.WhatId = acc.id;
			T.Subject = 'Other';
			T.status = 'Offen';
			//T.ActivityDate = Date.Today()-2;
			T.description = 'New  Work';
			insert T;

        	T.ActivityDate = Date.Today()-2;
        	update T;
        
        	Task T2 = new Task();
    		T2.WhatId = acc.id;
    		//T2.AccountId = acc.Id;
			T2.Subject = 'Other';
			T2.status = 'Completed';
            T2.Result__c = 'Entscheider erreicht';
			//T.ActivityDate = Date.Today()-2;
			T2.description = 'Test Task';
			insert T2;
        
        	list<TaskWrapper> ListTaskWr_Sorted = new list<TaskWrapper>();
        
			acc.LastClosedTask__c = null;
			update acc;
    		
    		
    		TaskWrapper TW = new TaskWrapper(t);
    		TW.compareTo(TW);
    		
    		CaseWrapper CW = new CaseWrapper(cs);
    		CW.compareTo(CW);
    		
    		Test.StartTest();
        	Batch_LastActivity btc = new Batch_LastActivity();
        	
        
            Database.executeBatch(btc, 1);
            //Schedule_Lifepoints_CounterBatchN.scheduleMe();
        	Test.stopTest();
    	}
    	@isTest
    	static void myUnitTest2() {
   			Account acc2 = new Account();
            acc2.Health__c = 100;
            acc2.Phone = 'ka';
            acc2.Name = 'Testa';
            acc2.Industry = 'KFZa';
        	acc2.Website = 'www.teast.com';
        	acc2.industry_detail__c = 'KFZ Gutachter';
            acc2.LastClosedTask__c = date.today()-15;
        	
            insert acc2;
        
        	Contract__c contr = new Contract__c();
            contr.Name = 'test2';
            contr.Account__c = Acc2.Id;
            contr.product_id__c = '5472';
            contr.started_date__c = date.today()+270;
        	contr.Status__c = '1';
        
            insert contr; 
        
            Account acc = new Account();
            acc.Health__c = 80;
            acc.Phone = 'ka';
            acc.Name = 'Test';
            acc.Industry = 'KFZ';
        	acc.Website = 'www.test.com';
        	acc.industry_detail__c = 'KFZ Gutachter';
        	acc.AdwordsContract__c = contr.Id;
            acc.LastClosedTask__c = date.today()-15;
        	//acc.AdWords_Start_Date__c = contr.started_date__c;
        	//acc.LP_Start_Date__c = acc.AdWords_Start_Date__c;
        
        	
            insert acc;
        
        	Account acc3 = new Account();
            acc3.Health__c = 60;
            acc3.Phone = 'ka';
            acc3.Name = 'Test';
            acc3.Industry = 'KFZ';
        	acc3.Website = 'www.test.com';
        	acc3.industry_detail__c = 'KFZ Gutachter';
        	acc3.AdwordsContract__c = contr.Id;
        	acc3.Key_Account__c = 'Key Account';
            
        	//acc3.AdWords_Start_Date__c = contr.started_date__c.Id;

        	insert acc3;
			/*
            Contract__c contr2 = new Contract__c();
            contr2.Name = 'test2';
            contr2.Account__c = Acc3.Id;
            contr2.product_id__c = '5472';
            contr2.started_date__c = date.today()+30;
        	contr2.Status__c = '1';
        
            insert contr2; 
            */
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
            insert u;
            
            Case cs = new Case();
            cs.OwnerId = u.Id;
            cs.Status = 'Offen';
            cs.Origin = 'Outbound - Call';
            cs.Reason = '5';
            cs.Service_Fall__c = 'Kundenbriefing durchführen';
            cs.Subject = 'Rechnung nicht erhalten';
            cs.AccountId = acc.Id;
            cs.CreatedFromBatch__c = true;
        	cs.Call_To_Action__c = cs.OwnerId;
            
            insert cs;
        
        	Case cs2 = new Case();
            cs2.OwnerId = u.Id;
            cs2.Status = 'Offen';
            cs2.Origin = 'Outbound - Call';
            cs2.Reason = '5';
            cs2.Service_Fall__c = 'Kundenbriefing durchführen';
            cs2.Subject = 'Rechnung nicht erhalten';
            cs2.AccountId = acc.Id;
            cs2.CreatedFromBatch__c = true;
        	cs2.Call_To_Action__c = cs2.OwnerId;
        
            insert cs2;
        
        	Case cs3 = new Case();
            cs3.OwnerId = u.Id;
            cs3.Status = 'Offen';
            cs3.Origin = 'Inbound - Mail';
            cs3.Reason = '5';
            cs3.Service_Fall__c = 'Kundenbriefing durchführen';
            cs3.Subject = 'Rechnung nicht erhalten';
            cs3.AccountId = acc.Id;
            cs3.CreatedFromBatch__c = true;
        	cs3.Call_To_Action__c = cs2.OwnerId;
        
            insert cs3;
        	//cs3.origin= 'Inbound - Mail';
        	//update cs3;
    
        	cs2.Status = 'Geschlossen - gelöst';
        
        	update cs2;
    		Test.StartTest();
			Batch_SetInitialHealth btc = new Batch_SetInitialHealth();
            Database.executeBatch(btc, 2);
        	Test.stopTest();
        	
    	}
    	
    	
    }