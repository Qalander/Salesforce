/**
 * Class BudgetShareHandler
 *
 * Trigger Handler for the BudgetShare__c SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class BudgetShareHandler implements ITrigger
{   
    Map<string, User> userEmailMap = new Map<string, User>();
    
    // Constructor
    public BudgetShareHandler()
    {
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {
        if (Trigger.IsInsert){
            
            List<string> emails = new List<string>();
            
            for (sObject share: Trigger.new)
                emails.add((string)share.get('seller_email__c'));
                
            List<User> userList = [Select Id, Email FROM User WHERE Email in :emails];
            
            for (User u: userList)
                userEmailMap.Put(u.Email, u);
        }
    }
    
    public void bulkAfter()
    {
    }
        
    public void beforeInsert(SObject so)
    {
        if (userEmailMap.ContainsKey((string)so.get('seller_email__c')))
            so.put('Seller__c', userEmailMap.get((string)so.get('seller_email__c')).Id);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
    
    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        if (Trigger.IsInsert && Trigger.IsAfter){
            Map<Id, object> posIds = new Map<Id, object>();
            
            for (sObject share :Trigger.new)
                posIds.put((Id)share.get('Position__c'), null);
                
            string timeStamp = (string)Trigger.New[0].get('TimeStamp__c');
               
            System.Debug('Deleting all shares without timestamp: ' + timestamp);
                
            delete [Select Id FROM BudgetShare__c WHERE Position__c in :posIds.KeySet() AND TimeStamp__c != :timeStamp];
            
            List<Position__c> positionList = [SELECT Id, (Select Seller__r.Name, seller_share_percent__c FROM BudgetShares__r) from Position__c WHERE Id in : posIds.KeySet()];
            
            for (Position__c pos: positionList){
                pos.Seller__c = '';
                for (BudgetShare__c share: pos.BudgetShares__r)
                    pos.Seller__c += share.Seller__r.Name + ': ' + share.seller_share_percent__c + '%; ';
            }
                    
            update positionList;
        }
    }
}