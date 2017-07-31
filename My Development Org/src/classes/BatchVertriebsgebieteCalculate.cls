global class BatchVertriebsgebieteCalculate implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
	global BatchVertriebsgebieteCalculate (){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    	string ListVertriebsgebiete = 'SELECT Id, Vertriebsgebiet__c, BillingPostalCode FROM Account WHERE Vertriebsgebiet__c = \'Telesales/Omnea\'';
        return Database.getQueryLocator(ListVertriebsgebiete);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
    	
    	list<Account> accUpdate = new List<Account>();
    	for(Account acc : scope)
        {
            acc.Vertriebsgebiet__c = VertriebsgebietCalculator.calculateVertriebsgebiet(acc.BillingPostalCode);
            accUpdate.add(acc);
        }
        
        if(accUpdate.size() > 0){
            
            Update accUpdate;
        }	
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :BC.getJobId()];
        system.debug('JobId :' + a.id);
        System.abortJob(a.Id);
   }
    
}