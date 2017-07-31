@isTest(SeeAllData=true)        
private class TaskHandler_Test {

	@isTest
    static void myUnitTest() {

        
            /*Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User objUser = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = ObjProfile.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        		insert objUser;*/
        
 Profile p = [SELECT Id FROM Profile WHERE Name='Standortleiter']; 
      User u = new User(Alias = 'stand123', Email='standarduser12346z@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduserrtzr6@testorg.com');
        insert (u);
         
                
            Account objAccount = new Account();
            objAccount.Name = 'Test Account';
            objAccount.Phone = 'ka';
            objAccount.Website = 'www.test.com';
            objAccount.Industry = 'Handel';
            objAccount.industry_detail__c = 'Brennstoffe';
            objAccount.LastClosedTask__c = date.newinstance(2017, 01, 01);
        
        		insert objAccount;
        
            objAccount = [SELECT Id, Name, Phone, Website, Industry, industry_detail__c FROM Account Where Id =: objAccount.Id];
            

        	Task objTask = new Task();
	        objTask.OwnerId = u.Id;
	        objTask.Subject = 'Test';
	        objTask.Status = 'Nicht begonnen';
	        objTask.Priority = 'Normal';
	        objTask.ActivityDate = Date.Today();
	        objTask.WhatId = objAccount.Id;
        	objTask.Result__c = 'Entscheider erreicht';
        
        		insert objTask;

      

        	objTask.Status = 'Completed';

        		update objTask;

        
     Lead l = new Lead( ownerid = u.id,
                        Company = 'Account',
                        Phone  = '+4946738278',
                        Website  = 'www.hallo.de',
                        Industry = 'Baugewerbe',
                        industry_detail__c ='Arbeitsbühne',
                        status ='Offen',
                        LeadSource ='Andere',
         				lastname='Last Name',
         				firstname='First Name'
                      );
        
        insert(l);
        task t = new task(whoid = l.id,
          ownerid = u.id,
             subject ='dfgthjk',
                          ActivityDate = Date.today(),
                          status = 'Offen',
                          Priority ='Normal',
                          Result__c ='Entscheider erreicht'
        );
        insert (t);

      Test.startTest();
        	System.runAs(u) {
 
      
         // The following code runs as user 'u' 
        TaskHandler vTask = new TaskHandler();
          vTask.afterInsert(t);  
          vTask.andFinally();
      }


	
        Test.stopTest();
    }
}