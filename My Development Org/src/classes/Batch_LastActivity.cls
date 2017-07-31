global class Batch_LastActivity implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
    global Batch_LastActivity (){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string Query = 'SELECT Id, Name, LastClosedTask__c, Projektmanager__c, AdWords_Start_Date__c, SEO_Start_Date__c, '+
        'OwnerId, Health__c, Vertriebsgebiet__c, Customer_Status__c, LP_Start_Date__c, Phone FROM Account '+
        'WHERE (Customer_Status__c = \'Neustarter\' OR Customer_Status__c = \'Neukunde\' OR Customer_Status__c = \'Bestandskunde\' OR '+
        'AdWordsContract__c != null OR SEOContract__c != null) and LastClosedTask__c = NULL';
        system.debug('***Query  = ' + Query );
       return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
    	try {
    		system.debug('****Execute!');
	    	map<Id,List<TaskWrapper>> mapIdAccountPerListTask = new map<Id, List<TaskWrapper>>();
	    	map<Id,List<CaseWrapper>> mapIdAccountPerListCase = new map<Id, List<CaseWrapper>>();
	    	map<Id,Account> mapIdAccountPerAccount = new map<Id, Account>();
	    	set<Id> SetIdAccount = new set<Id>();
	    	for(Account Acc : scope){
	    		SetIdAccount.add(Acc.Id);
                system.debug('**************** SetIdAccount = '+ Acc.Id);
	    		mapIdAccountPerAccount.put(Acc.Id, Acc);
                system.debug('**************** mapIdAccountPerAccount = '+ Acc.Id);
	    	}
	    	for(Task T : [Select Id, AccountId, ActivityDate from Task where Status = 'Completed' and (Result__c = 'Entscheider erreicht' or Result__c = 'Entscheider erreicht - Zweitgespräch nach Unterlagen' or (Type = 'Email' and (NOT Subject like 'Email: Wir haben Ihre Anfrage erhalten - Thema%'))) and AccountId IN: SetIdAccount]){
				system.debug('****** AccountId = ' + T.AccountId);
                if(mapIdAccountPerListTask.get(t.AccountId) == null)
		                mapIdAccountPerListTask.put(t.AccountId, new list<TaskWrapper>());
		            mapIdAccountPerListTask.get(t.AccountId).add(new TaskWrapper(T));
	    	}
	    	for(Case C : [Select Id, AccountId, isClosed, ClosedDate from Case where isClosed = true and AccountId IN: SetIdAccount]){
                system.debug('****** AccountId = ' + C.AccountId);
	    		if(mapIdAccountPerListCase.get(c.AccountId) == null)
	                mapIdAccountPerListCase.put(c.AccountId, new list<CaseWrapper>());
	            mapIdAccountPerListCase.get(c.AccountId).add(new CaseWrapper(C));
	    	}
	    	map<Id,List<TaskWrapper>> mapIdAccountPerListTask_Sorted = new map<Id, List<TaskWrapper>>();
	    	for(Id IdAcc_Task : mapIdAccountPerListTask.keyset()){
	    		list<TaskWrapper> ListTaskWr_Sorted = new list<TaskWrapper>();
	    		if(mapIdAccountPerListTask.size()>0){
	    			ListTaskWr_Sorted = mapIdAccountPerListTask.get(IdAcc_Task);
	    			ListTaskWr_Sorted.sort();
	    			mapIdAccountPerListTask_Sorted.put(IdAcc_Task, ListTaskWr_Sorted);
	    		}
	    	}
	    	map<Id,List<CaseWrapper>> mapIdAccountPerListCase_Sorted = new map<Id, List<CaseWrapper>>();
	    	for(Id IdAcc_Case : mapIdAccountPerListCase.keyset()){
	    		list<CaseWrapper> ListCaseWr_Sorted = new list<CaseWrapper>();
	    		if(mapIdAccountPerListCase.size()>0){
	    			ListCaseWr_Sorted = mapIdAccountPerListCase.get(IdAcc_Case);
	    			ListCaseWr_Sorted.sort();
	    			mapIdAccountPerListCase_Sorted.put(IdAcc_Case, ListCaseWr_Sorted);
	    		}
	    	}
	    	map<Id, Date> MapIdAccountPerClosedDateJung = new map<Id, Date>();
	    	for(Id AccId : mapIdAccountPerListTask_Sorted.keyset()){
	    		system.debug('****AccId = ' + AccId);
	    		Task TaskJunger;
	    		if(mapIdAccountPerListTask_Sorted.get(AccId) != null){
	    			TaskJunger = mapIdAccountPerListTask_Sorted.get(AccId)[mapIdAccountPerListTask_Sorted.get(AccId).size()-1].Ta;
					system.debug('****AccId = ' + AccId + '*****TaskJunger + ' + TaskJunger.Id);
				}
				Case CaseJunger;
				if(mapIdAccountPerListCase_Sorted.get(AccId) != null){
	    			CaseJunger = mapIdAccountPerListCase_Sorted.get(AccId)[mapIdAccountPerListCase_Sorted.get(AccId).size()-1].Ca;
					system.debug('****AccId = ' + AccId + '*****CaseJunger + ' + CaseJunger.Id);
				}
				if(CaseJunger != null && TaskJunger != null){
					Date CloseCaseJunger = Date.newinstance(CaseJunger.ClosedDate.year(), CaseJunger.ClosedDate.month(), CaseJunger.ClosedDate.day());
					Date CloseTasKJunger = TaskJunger.ActivityDate;
					if(CloseCaseJunger > CloseTasKJunger){
						MapIdAccountPerClosedDateJung.put(AccId, CloseCaseJunger);
					}else{
						MapIdAccountPerClosedDateJung.put(AccId, CloseTasKJunger);
					}
					
				}else if(CaseJunger != null && TaskJunger == null){
					Date CloseCaseJunger = Date.newinstance(CaseJunger.ClosedDate.year(), CaseJunger.ClosedDate.month(), CaseJunger.ClosedDate.day());
					MapIdAccountPerClosedDateJung.put(AccId, CloseCaseJunger);
				}else if(CaseJunger == null && TaskJunger != null){
					Date CloseTasKJunger = TaskJunger.ActivityDate;
					MapIdAccountPerClosedDateJung.put(AccId, CloseTasKJunger);
				}
	    			
	    	}
	    	list<Account> ListAccountToUpdate = new list<Account>();
	    	for(Id IdACC : MapIdAccountPerClosedDateJung.keyset()){
	    		Account Acc= mapIdAccountPerAccount.get(IdACC);
	    		Acc.LastClosedTask__c = MapIdAccountPerClosedDateJung.get(IdACC);
	    		ListAccountToUpdate.add(Acc);
	    	}
	    	if(ListAccountToUpdate.size()>0)
	    		Update ListAccountToUpdate;
		    	
    	}catch(Exception e){
    		System.debug('******Exception e '+e +' at line '+e.getLineNumber());
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