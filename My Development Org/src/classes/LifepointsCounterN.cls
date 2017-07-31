global with sharing class LifepointsCounterN implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
    global LifepointsCounterN (){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String Query = 'SELECT Id, Name, RecordType.Name, AdwordsContract__c , SEOContract__c, LastClosedTask__c, Projektmanager__c, AdWords_Start_Date__c, '+
            'SEO_Start_Date__c, OwnerId, Health__c, Vertriebsgebiet__c, Customer_Status__c, LP_Start_Date__c '+
            'FROM Account WHERE RecordType.Name = \'Kunde\' and (CustomerStateAdwords__c = \'Kunde\' or CustomerStateSeo__c = \'Kunde\') and (Customer_Status__c = \'Bestandskunde\' '+
            'or Customer_Status__c = \'Neukunde\' or Customer_Status__c = \'Neustarter\') and (StatusSeo__c = \'Aktiv\' or StatusAdwords__c = \'Aktiv\') '+
            'AND (Key_Account__c != \'Kooperationspartner\' and Key_Account__c != \'Whitelabel-Partner\' and Key_Account__c != \'Indirekter Kunde - kein Kontakt\')';
        
        
        Database.QueryLocator q = Database.getQueryLocator(Query);
        Database.QueryLocatorIterator it =  q.iterator();
        System.debug('Test if has next :' +  it.hasNext());
        
        
        system.debug('***Query  = ' + Query );
        return Database.getQueryLocator(Query);
        
       
        
       
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
    	system.debug('***** exceute');
        
    	set<Id> SetAccountIdScope = new set<Id>();
    	list<Task> ListTaskToCreate = new list<Task>();
    	list<Case> ListCaseToCreate = new list<Case>();
    	list<Account> listAccountToUpdate = new list<Account>();
    	list<Id> ListAccountIdToCheckCase = new list<Id>();
    	
    	try {
	    	for(Account a : scope){
                system.debug('### acc: '+a.Name);
	            system.debug('***** a = ' +a.Id);
	    		if((!a.Name.containsIgnoreCase('regiohelden') && !a.Name.containsIgnoreCase('Garant') && !a.Name.containsIgnoreCase('BAL Tours GmbH') && !a.Name.containsIgnoreCase('BAL-Tours GmbH')) ||
                  a.Name == 'Garant Immobilien Holding GmbH' ){
	                system.debug('***** regiohelden');
	                if(a.AdWords_Start_Date__c != null || a.SEO_Start_Date__c != null){
	                    system.debug('***** checks');
	                    
                        Integer NDaysLP = 0;
                        /*
	                    Integer NDays = 0;
						Integer NDaysSeo = 0;
	                    if(a.AdWords_Start_Date__c != null){
	                        NDays = date.today().daysBetween(a.AdWords_Start_Date__c) * -1;
	                    }
	                    if(a.SEO_Start_Date__c != null){
	                        NDaysSeo = date.today().daysBetween(a.SEO_Start_Date__c) * -1;
	                    }*/
                        if(a.LP_Start_Date__c != null){
	                        NDaysLP = date.today().daysBetween(a.LP_Start_Date__c) * -1;
	                    }
                        
                        
                        if (NDaysLP <= 30){
                            system.debug('****NDaysLP <= 30 = ' + a.Id+'  -a.NDaysLP= '+NDaysLP);
                            
                            a.Health__c = a.Health__c - 3.6;
                        }else if(NDaysLP <= 180){
                            a.Health__c = a.Health__c - 1.8;
                            system.debug('****NDaysLP <= 180 = ' + a.Id+'  -a.NDaysLP= '+NDaysLP);
                            
                            
                        }else{
                            a.Health__c = a.Health__c - 1.8;
                            system.debug('****NDaysLP else = ' + a.Id+'  -a.NDaysLP= '+NDaysLP);
                            
                        }
                       
                        system.debug('### '+a.Health__c +' acc: '+a.Name);
                        if(a.Health__c < 50) {
                            ListAccountIdToCheckCase.add(a.Id);
                        }
                        if(a.Health__c < 0){
                        	system.debug('***** Health__c =' + a.Health__c);
                        	a.Health__c = 0;
                        }
                        listAccountToUpdate.add(a);
	    			}
	                SetAccountIdScope.add(a.Id);
	    		}
    		
    		}
    		
    	}catch(Exception e){
    		System.debug(e);
		}
    	
        map<Id, list<Case>> MapIdAccperCase =  new map<Id, list<Case>>();
        if(ListAccountIdToCheckCase.size()>0){
            for(Case C : [Select Id, AccountId, CreatedFromBatch__c 
                          from Case where AccountId IN: ListAccountIdToCheckCase  and
                         CreatedFromBatch__c = true and isClosed = false]){
                if(MapIdAccperCase.get(C.AccountId) == null)
                    MapIdAccperCase.put(C.AccountId, new list<Case>());
                MapIdAccperCase.get(C.AccountId).add(C);
            }
        }
        
        for(Id IdAcc : ListAccountIdToCheckCase){
            if(MapIdAccperCase.get(IdAcc) != null){

            }else{
                case newCase = new case();
                newCase.AccountId = IdAcc;
                newCase.Origin = 'Outbound Call';
                newCase.Status = 'Offen';
                newCase.CreatedFromBatch__c = true;
                newCase.Subject = 'Account kontaktieren - Zeit abgelaufen';
                ListCaseToCreate.add(newCase);
                
            }
        }
    	if(listAccountToUpdate.size()>0)
    		update listAccountToUpdate;
    	if(ListCaseToCreate.size()>0)
    		insert ListCaseToCreate;
    	
    	
	}
   global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :BC.getJobId()];
        system.debug('JobId :' + a.id);
        System.abortJob(a.Id);
   }
}