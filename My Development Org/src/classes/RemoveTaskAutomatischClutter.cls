global class RemoveTaskAutomatischClutter implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'select Id from Task where Subject like \'Email: Wir haben Ihre Anfrage erhalten%\'';
		System.debug('*******query = '+query);
        return Database.getQueryLocator(query);
   } // close the start method.
   global void execute(Database.BatchableContext BC, List<Task> scope ){
        list<Task> ListTaskToDelete = New list<Task>();
		for(Task em : scope){
           ListTaskToDelete.add(em);
            System.debug('*******Email.Id = '+em.Id);
        }
        System.debug('*******ListTaskToDelete.size() = '+ListTaskToDelete.size());
       if(ListTaskToDelete.size()>0)
           delete ListTaskToDelete;
       } 
   global void finish(Database.BatchableContext BC){
       /*if(!Test.isRunningTest()){ 
            Database.executeBatch(new RemoveEmailCaseClutter(),2);
       }*/
   		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :BC.getJobId()];
       	System.abortJob(a.Id);
       integer count = System.purgeOldAsyncJobs(Date.today());
   }
}