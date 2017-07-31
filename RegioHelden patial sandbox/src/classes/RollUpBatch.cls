global class RollUpBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global RollUpBatch(string q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<Id, sObject> sObjMap = new Map<Id, sObject>(scope);
        
        RollUpManager mng = new RollUpManager();
        mng.RollUpTasks(sObjMap.keySet());
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}