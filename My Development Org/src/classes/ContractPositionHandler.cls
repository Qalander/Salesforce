/**
 * Class ContractPositionHandler
 *
 * Trigger Handler for the ContractPosition SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class ContractPositionHandler implements ITrigger
{   
    List<Id> updateAccounts = new List<Id>(); 
        
    // Constructor
    public ContractPositionHandler()
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
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void andFinally()
    {         
        if (Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsDelete)){
        
            List<sObject> values;
            if (Trigger.IsInsert || Trigger.IsUpdate)
                values = Trigger.New;
            else 
                values = Trigger.Old;
                
            Map<Id, object> contractIds = new Map<Id, object>();
            List<sObject> triggerValues = Trigger.IsInsert ? Trigger.New : Trigger.Old;
            for (sObject so: triggerValues)
                contractIds.put((Id)so.get('Contract__c'), null);            
                
            List<Contract__c> contracts = 
                [Select 
                    Id, 
                    (Select Id, valid_from__c FROM Positions__r ORDER BY valid_from__c ASC)
                FROM Contract__c
                WHERE ID in :contractIds.keySet()];
            
            List<Position__c> updatePositions = new List<Position__c>();
               
            for (Contract__c con: contracts){
                Id firstId;
                Id previousId;
                for (Position__c pos: con.Positions__r){
                    updatePositions.add(new Position__c(Id = pos.Id, PreviousPosition__c = previousId));
                    If(firstId == Null)
                    {
                        firstId = pos.id;
                    }
                    previousId = pos.Id;
                }
                con.LatestPosition__c = previousId;
            }
            
            upsert updatePositions;
            update contracts;
        }
    }
}