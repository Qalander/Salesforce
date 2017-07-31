@isTest
private class TestAccountOwnerManager {

    static testMethod void testMyWebSvc()
  {
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='kjlj@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='hhkhk@testorg.com');
        insert u;
        
        List<Account> ListAccount = new List<Account>();
        //listAccount= (Account[]) Test.loadData(Account.sObjectType, 'sfseLastModDateInPast');
        for(integer i=0; i<10; i++) {
        	Account acc = new Account();
        	acc.Name='Abc' + i;
        	acc.Email__c = 'AAdaniel.hankammer@ilume.de' + i;
        	acc.Projektmanager__c = u.Id;
        	acc.Phone = '+493022354125' + i;
        	acc.BypassValidation__c = TRUE;
            acc.Industry = 'Baugewerbe';
            acc.industry_detail__c = 'Arbeitsbühne';
            ListAccount.add(acc);
        }
        insert ListAccount;
        list<Id> ListAccountId = new List<Id>();
        for(Account Acc : ListAccount){
        	ListAccountId.add(Acc.Id);
        }
      	AccountOwnerManager.HandleAccounts( ListAccountId );
  }
}