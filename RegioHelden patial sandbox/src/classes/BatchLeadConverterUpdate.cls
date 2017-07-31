global class BatchLeadConverterUpdate implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {

		String Query = 'SELECT Id, Name, OwnerId, Previous_User__r.Id, Produktauswahl__c, Status, LeadSource, RecordType.Name FROM Lead WHERE RecordType.Name = \'TeleSales\' AND (Status = \'Präsentation – kein Interesse\' OR Status = \'Schlechte Erreichbarkeit\' OR Status = \'Kein Interesse\' OR Status = \'kein verkaufbares Produkt\') AND (LeadSource = \'AdWords Telesales\' OR LeadSource = \'Bing Telesales\' OR LeadSource = \'Facebook Telesales\' OR LeadSource = \'GDN Telesales\' OR LeadSource = \'Telesales\') AND isConverted = false';
   		 return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        try {
            for(Lead l : scope){
                
            //if(l.isConverted == false){
	        //if (Lold.Get('OwnerId') != L.get('OwnerId'))
	            //sObjectIds.add(L.Id);
	           
	        if((l.status == 'Präsentation – kein Interesse' || l.status == 'Schlechte Erreichbarkeit' || l.status == 'Kein Interesse' || l.status == 'kein verkaufbares Produkt') && 
	        (l.LeadSource == 'AdWords Telesales' || l.LeadSource == 'Bing Telesales' || l.LeadSource == 'Facebook Telesales' ||  
	        	l.LeadSource == 'GDN Telesales' || l.LeadSource == 'Telesales')){
                    
                    l.Produktauswahl__c = 'Kostenloses Produkt';
                    System.debug('###### l.Produktauswahl__c = '+ l.Produktauswahl__c);
                    
                    Lead LtoConvert = [Select id, Previous_User__r.Id, OwnerId from Lead where Id =: l.Id];
                    Database.LeadConvert Leadconvert = new Database.LeadConvert();
                    Leadconvert.setLeadId(LtoConvert.Id);
                    
                    if(LtoConvert.Previous_User__r.Id != null) {
        				Leadconvert.setOwnerId(LtoConvert.Previous_User__r.Id);
                    }else {
    					Leadconvert.setOwnerId(LtoConvert.OwnerId);
                        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true limit 1];
                        Leadconvert.setConvertedStatus('Produkt gekauft');
                        //Leadconvert.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to   create an opportunity from Lead Conversion 
                        System.debug('###### OwnerId = '+ l.OwnerId);
                        Database.LeadConvertResult Leadconverts = Database.convertLead(Leadconvert);
                    }
                    
                }else {
                    l.Produktauswahl__c = '';
                    System.debug('###### l.Produktauswahl__c ELSE = '+ l.Produktauswahl__c);
                }
                //}
            }
            
        }catch(Exception e) {
            System.debug('******Exception e '+e +' at line '+e.getLineNumber());
        }
    }    

    global void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        system.debug('JobId :' + a.id);
        System.abortJob(a.Id);
    }    

}