@isTest(SeeAllData=true)
public class TestLastActivityBatch {

  @isTest
  public static void myUnitTest() {

      	Test.startTest();
      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='kjlj@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='hhkhk@testorg.com');
        insert u;
        
        List<String> ids = new List<String>();
        
        //List<Account> ListAccount = new List<Account>();
        //listAccount= (Account[]) Test.loadData(Account.sObjectType, 'sfseLastModDateInPast');
        //for(integer i=0; i<10; i++) {
        	Account acc = new Account();
        	acc.Name='Abc' ;
        	acc.Email__c = 'AAdaniel.hankammer@ilume.de' ;
        	acc.Projektmanager__c = u.Id;
        	acc.Phone = '+493022354125';
        	acc.BypassValidation__c = TRUE;
            acc.Industry = 'Baugewerbe';
            acc.industry_detail__c = 'Arbeitsbühne';
            
            //if (ListAccount != null && ListAccount.size() > 0) {
                
                //ListAccount.add(acc);
            //}else {
               // system.debug('####Error: ListAccount ' + ListAccount[0]);
            //}
            
        //}
        insert acc;
    	system.debug('####Insert: Account ' + acc);
        //system.debug('####Insert: ListAccount ' + ListAccount);
        
        RecordType rt = [select id, Name from RecordType where SobjectType='Lead' and Name='Standard' Limit 1];
        
        //list<Lead> listLead = new list<Lead>();
        //for(integer k=0; k<10;k++){
        	
        	Lead lead = new Lead();
        	lead.RecordTypeId = rt.Id;
        	lead.LastName = 'Test Name';
            lead.Company = 'Test Company';
            lead.Website = 'www.test.com';
            lead.Phone = 'ka';
        	lead.Industry = 'Recht';
            lead.industry_detail__c = 'Arbeitsrecht';
            lead.Status = 'kontaktiert';
            lead.LeadSource = 'Cylex';
            
            //if (!listLead.isEmpty()) {
            //listLead.add(lead);
            //}
        //}
        insert lead;
        
        //list<Task> listtask = new list<Task>();
        //for(integer j=0; j<10;j++){
        	
        	Task tskTest = new Task();
        	tskTest.OwnerId=u.Id;
        	tskTest.ActivityDate=Date.Today();
        	tskTest.Description='Test Task';
        	tskTest.Priority='Low';
        	tskTest.Status='Completed';
        	tskTest.Subject='Test Task';
            //tskTest.IsDeleted = false;
            //tskTest.IsRecurrence = false;
        	
        	//tskTest.WhatId = ListAccount[j].id;
            //tskTest.WhoId = listLead[j].id;
            //if (!listtask.isEmpty()) {
        	//listtask.add(tskTest);
            //}
        	
       // }
        //insert tskTest;

        //list<Event> listEvent = new list<Event>();
        //for(integer l=0; l<10; l++){
        	
        	Event eve = new Event();
        	eve.OwnerId = u.Id;
            eve.Subject = 'Test Event';
            eve.Type = 'Test Type';
            eve.StartDateTime = Date.Today();
            eve.EndDateTime = Date.Today();
            //eve.IsDeleted = false;
            //eve.IsRecurrence = false;
            //eve.WhatId = ListAccount[l].id;
            //eve.WhoId = listLead[l].id;
            //
            //if (!listtask.isEmpty()) {
            //listEvent.add(eve);
            //}//
       // }
        insert eve;
        
        
    
        
       
      	LastActivityBatch sb = new LastActivityBatch();
      	//sb.str_SOQL += 'LIMIT 200';
        Database.executeBatch(sb,1);
        Test.stopTest();
	      
    }
}