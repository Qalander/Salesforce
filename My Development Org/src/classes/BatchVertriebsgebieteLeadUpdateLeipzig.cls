global class BatchVertriebsgebieteLeadUpdateLeipzig implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
	global BatchVertriebsgebieteLeadUpdateLeipzig (){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        
        string v_Gebiet ='Leipzig';
        
        list<Vertriebsgebiet__c> aGebiet = [select id,plz__c from Vertriebsgebiet__c where name = :v_Gebiet ];  	
        list<string> plz = new list<string>();
        
        for(Vertriebsgebiet__c vg : aGebiet)
                {
                    plz.add(vg.plz__c)  ;
                }

    	string ListVertriebsgebiete = 'SELECT Id, Vertriebsgebiet__c, PostalCode FROM Lead WHERE PostalCode =:plz and Vertriebsgebiet__c <> :v_Gebiet AND isConverted = false';
        return Database.getQueryLocator(ListVertriebsgebiete);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope){
    	
    	list<Lead> leadUpdate = new List<Lead>();
    	for(Lead lead : scope)
        {
            lead.Vertriebsgebiet__c = VertriebsgebietCalculator.calculateVertriebsgebiet(lead.PostalCode);
            leadUpdate.add(lead);
        }
        
        if(leadUpdate.size() > 0){
            
            Update leadUpdate;
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