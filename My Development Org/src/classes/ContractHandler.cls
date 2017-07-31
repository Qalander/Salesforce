/**
 * Class ContractHandler
 *
 * Trigger Handler for the Contract SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class ContractHandler implements ITrigger
{   
    List<Id> updateAccounts = new List<Id>(); 
        
    // Constructor
    public ContractHandler()
    {
    }
   
    public void bulkBefore()
    {
    }
    
    public void bulkAfter()
    {
    }
        
    public void beforeInsert(SObject so)
    {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so)
    {
        updateAccounts.add((Id)so.get('Account__c'));
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        updateAccounts.add((Id)so.get('Account__c'));
    }
    
    public void afterDelete(SObject so)
    {
        updateAccounts.add((Id)so.get('Account__c'));
    }
    
    public void andFinally()
    { 
       List<Account> adwordsResult = 
        [SELECT 
            Id,
            (Select Id FROM Contracts__r WHERE Type__c = '1' ORDER BY Status__c ASC LIMIT 1)
        FROM Account
        WHERE Id in :updateAccounts];
        
        List<Account> seoResult = 
        [SELECT 
            Id,
            (Select Id FROM Contracts__r WHERE Type__c = '7' ORDER BY Status__c ASC LIMIT 1)
        FROM Account
        WHERE Id in :updateAccounts];
        
        Map<Id, Account> accs = new Map<Id, Account>();
        
        for (Account awAccount: adwordsResult)
            if (awAccount.Contracts__r.Size() == 0)
                awAccount.AdwordsContract__c = null;
            else
                awAccount.AdwordsContract__c = awAccount.Contracts__r[0].Id;
        
        for (Account awAccount: seoResult)
            if (awAccount.Contracts__r.Size() == 0)
                awAccount.SeoContract__c = null;
            else
                awAccount.SeoContract__c = awAccount.Contracts__r[0].Id;               
          
        update adwordsResult; 
        update seoResult;
    }
}