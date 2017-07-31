global class RemoveEmailCaseClutter implements Database.Batchable<sObject>{
	    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'select id, Incoming, Subject from EmailMessage where Subject like \'Wir haben Ihre Anfrage erhalten%\' and Incoming = false';
		System.debug('*******query = '+query);
        return Database.getQueryLocator(query); 
   } // close the start method.
   global void execute(Database.BatchableContext BC, List<EmailMessage> scope){
       list<EmailMessage> ListEmailToDelete = New list<EmailMessage>();
     	for(EmailMessage emp : scope){
     		ListEmailToDelete.add(emp);
            System.debug('*******Email.id = '+emp.id);
        }
        System.debug('*******ListEmailToDelete.size() = '+ListEmailToDelete.size());
       if(ListEmailToDelete.size()>0)
           delete ListEmailToDelete;
   } 
   global void finish(Database.BatchableContext BC){
       //list<EmailMessage> ListEmailToDelete = New list<EmailMessage>();
       //if(ListEmailToDelete.size()>0)
          // delete ListEmailToDelete;
       if(!Test.isRunningTest()){ 
           
        Database.executeBatch(new RemoveTaskAutomatischClutter(),100);
       }
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :BC.getJobId()];
       	System.abortJob(a.Id);
       integer count = System.purgeOldAsyncJobs(Date.today());
      } 
   }