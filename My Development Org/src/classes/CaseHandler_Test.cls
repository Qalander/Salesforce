@isTest        
private class CaseHandler_Test {

	@isTest
    static void myUnitTest() {

        
            Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User objUser = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = ObjProfile.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        		insert objUser;
        
            Account objAccount = new Account();
            objAccount.Name = 'Test Account';
            objAccount.Phone = 'ka';
            objAccount.Website = 'www.test.com';
            objAccount.Industry = 'Handel';
            objAccount.industry_detail__c = 'Brennstoffe';
            objAccount.LastClosedTask__c = date.newinstance(2017, 01, 01);
        
        		insert objAccount;
        
            objAccount = [SELECT Id, Name, Phone, Website, Industry, industry_detail__c FROM Account Where Id =: objAccount.Id];
            
            Case objCase = new Case();
            objCase.OwnerId = objUser.Id;
            objCase.Reason = 'Rechnung';
            objCase.Origin = 'Outbound - Mail';
            objCase.Status = 'Offen';
            //objCase.isClosed = true;
            objCase.ClosedDate = date.newinstance(2017, 01, 03);
        	objCase.AccountId = objAccount.Id;
        
        		insert objCase;
        
        	objCase = [SELECT Id, OwnerId, Reason, Origin, Status, ClosedDate FROM Case Where Id =: objCase.Id];
        
        Test.startTest();
        
        	objCase.Status = 'Geschlossen - gelöst';
        
        	update objCase;
        	
        
        /*
        
        Task objTask = new Task();
        objTask.OwnerId = objUser.Id;
        objTask.Subject = 'Test';
        objTask.Status = 'Nicht begonnen';
        objTask.Priority = 'Normal';
        objTask.ActivityDate = Date.Today();
        
        insert objTask;
        

        objTask.Status = 'Completed';

        
        update objTask;
        
        */
        
        Test.stopTest();
    }
}