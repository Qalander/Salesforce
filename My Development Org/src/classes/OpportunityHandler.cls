/**
 * Class OpportunityHandler
 *
 * Trigger Handler for the Opportunity SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class OpportunityHandler implements ITrigger {   
    Set<Id> sObjectIds = new Set<Id>();
    List<Id> updateAccounts = new List<Id>();
    Schema.FieldSet accPreview = Schema.SObjectType.Opportunity.fieldSets.AccountPreview;
        
    // Constructor
    public OpportunityHandler() {
    }
   
    public void bulkBefore() {
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
        /*
        Opportunity Opp = (Opportunity)so;
        
        if(Opp.RecordType.Name == 'TeleSales') {

            system.debug('****Opp.RecordType.Name = ' + Opp.RecordType.Name);
                
			if((Opp.status == 'Präsentation – Kein Interesse' || Opp.status == 'Schlechte Erreichbarkeit' || Opp.status == 'Kein Interesse' || Opp.status == 'kein verkaufbares Produkt') && 
	        (Opp.LeadSource == 'AdWords Telesales' || Opp.LeadSource == 'Bing Telesales' || Opp.LeadSource == 'Facebook Telesales' ||  
	        	Opp.LeadSource == 'GDN Telesales' || Opp.LeadSource == 'Telesales')){

                Opp.Produktauswahl__c = 'Kostenloses Produkt';    
	    		Opp.LeadConvertedFromPicklist__c = true;
	    		system.debug('****Opp.Produktauswahl__c Insert1 = ' + Opp.Produktauswahl__c);
	        }else if((Opp.status != 'Präsentation – kein Interesse' && Opp.status != 'Schlechte Erreichbarkeit' && Opp.status != 'Kein Interesse' || Opp.status == 'kein verkaufbares Produkt') ||
	        		(Opp.LeadSource != 'AdWords Telesales' && Opp.LeadSource != 'Bing Telesales' && Opp.LeadSource != 'Facebook Telesales' &&  
	        	Opp.LeadSource != 'GDN Telesales' && Opp.LeadSource != 'Telesales')){
	        	Opp.Produktauswahl__c = ''; 
	        	system.debug('****Opp.Produktauswahl__c Insert2 = ' + Opp.Produktauswahl__c);
	        }
                
            } */
        /*
        Opportunity Opp = (Opportunity)so;
        
        if(Opp.RecordType.Name == 'Standard') {
         
			system.debug('****Opp.RecordType.Name = ' + Opp.RecordType.Name);

			if((Opp.Lead_Status__c == 'Präsentation - kein Interesse' || Opp.Lead_Status__c == 'Schlechte Erreichbarkeit' || Opp.Lead_Status__c == 'Kein Interesse' || Opp.Lead_Status__c == 'kein verkaufbares Produkt') && 
	        (Opp.LeadSource == 'AdWords Telesales' || Opp.LeadSource == 'Bing Telesales' || Opp.LeadSource == 'Facebook Telesales' ||  
	        	Opp.LeadSource == 'GDN Telesales' || Opp.LeadSource == 'Telesales')){
                    
                    Opp.RecordType.Name = 'TeleSales';
                }else {
                    
                    system.debug('****Opp.RecordType.Name ELSE = ' + Opp.RecordType.Name);
                    //Opp.RecordType.Name = 'Standard';
                }
			            
        }*/
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        /*
        Opportunity Opp = (Opportunity)so;
        
        if(Opp.RecordType.Name == 'Standard') {
         
			system.debug('****Opp.RecordType.Name = ' + Opp.RecordType.Name);

			if((Opp.Lead_Status__c == 'Präsentation – Kein Interesse' || Opp.Lead_Status__c == 'Schlechte Erreichbarkeit' || Opp.Lead_Status__c == 'Kein Interesse' || Opp.Lead_Status__c == 'kein verkaufbares Produkt') && 
	        (Opp.LeadSource == 'AdWords Telesales' || Opp.LeadSource == 'Bing Telesales' || Opp.LeadSource == 'Facebook Telesales' ||  
	        	Opp.LeadSource == 'GDN Telesales' || Opp.LeadSource == 'Telesales')){
                    
                    Opp.RecordType.Name = 'TeleSales';
                }else {
                    
                    system.debug('****Opp.RecordType.Name ELSE = ' + Opp.RecordType.Name);
                    //Opp.RecordType.Name = 'Standard';
                }
			            
        }*/
    }
    
    public void beforeDelete(SObject so) {   
    }
    
    public void afterInsert(SObject so) {
        updateAccounts.add((Id)so.get('AccountId'));
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        for(Schema.FieldSetMember field: accPreview.getFields())
            if (so.get(field.getFieldPath()) != oldso.get(field.getFieldPath()))
                updateAccounts.add((Id)so.get('AccountId'));
        
         if (oldSo.Get('OwnerId') != so.get('OwnerId'))
            sObjectIds.add(so.Id);
            
        
    }
    
    public void afterDelete(SObject so) {
        updateAccounts.add((Id)so.get('AccountId'));
    }
    
    public void andFinally() {   
    	try {
        	List<Opportunity> opps = [Select Id FROM Opportunity WHERE AccountId in :updateAccounts ORDER BY CloseDate DESC];
        	List<Id> oppIds = new List<Id>();
        
        	for (Opportunity opp: opps)
            	oppIds.add(opp.Id);
        
	        sObjectUtil util = new sObjectUtil();
	        Map<Id, List<sObject>> accountMap = util.SelectsObjects(accPreview, 'AccountId', oppIds, ' ORDER BY CloseDate DESC');
	        Map<Id, string> tableMap = util.GenerateHtmlTable(accPreview, accountMap);
	        
	        List<Account> accs = [Select Id from Account WHERE Id in :updateAccounts];
	        for (Account acc: accs)
	            acc.OpportunitiesDesc__c = tableMap.get(acc.Id);
	        
	        update accs;
        }
        catch(Exception exc) {
        }
    }
}