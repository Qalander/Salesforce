global class AccountUpdateBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id from Account');
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Schema.FieldSet accPreview = Schema.SObjectType.Opportunity.fieldSets.AccountPreview;
        List<Id> accIds = new List<Id>();
        for (sObject acc: scope)
            accIds.add(acc.Id);
        
        List<Opportunity> opps = [Select Id FROM Opportunity WHERE AccountId in :accIds ORDER BY CloseDate DESC];
        List<Id> oppIds = new List<Id>();
        
        for (Opportunity opp: opps)
            oppIds.add(opp.Id);
        
        sObjectUtil util = new sObjectUtil();
        Map<Id, List<sObject>> accountMap = util.SelectsObjects(accPreview, 'AccountId', oppIds, ' ORDER BY CloseDate DESC');
        Map<Id, string> tableMap = util.GenerateHtmlTable(accPreview, accountMap);
        
        for (sObject acc: scope)
            acc.put('OpportunitiesDesc__c',tableMap.get(acc.Id));
        
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}