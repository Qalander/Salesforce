global class AccountOwnerManager {

    webservice static string HandleAccounts(List<string> accountIds){
    
        list<account> accountlist = new list<account>();

       if (accountIds == NULL) 
        { 
            return 'Bitte wähle mindestens einen Account aus'; 
        } 
       else 
        { 
            for (string accountid:accountIds) 
                { 
                    account a = new Account();
                    a.id = accountid; 
                    a.OwnerId = UserInfo.getUserId();
                    accountlist.add(a);
                    a.Accountpool__c = '';
                } 
        }

        if (accountlist.size() > 0 )
        {
            update accountlist; 
            
        }
       
        return 'Update erfolgreich';
    }
}