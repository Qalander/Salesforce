/**
 * Class LeadHandler
 *
 * Trigger Handler for the Lead SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class LeadHandler implements ITrigger {       
    
    Set<Id> sObjectIds = new Set<Id>();
    
    Map<String, String> leadToVertriebsgebietMap = new Map<String, String>();
    
    // Constructor
    public LeadHandler() {
    }
   
    public void bulkBefore() {
        
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(sObject Lead : Trigger.new)
            {
            	Lead L = (Lead)Lead;
            	if(!L.isConverted){
	                String vertiebsgebiet = (String) VertriebsgebietCalculator.calculateVertriebsgebiet(L.get('PostalCode'));
	                leadToVertriebsgebietMap.put((String)L.get('Id'), vertiebsgebiet);
            	}
            }
        }
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
        //so.put('Vertriebsgebiet__c', VertriebsgebietCalculator.calculateVertriebsgebiet(so.get('PostalCode')));
        Lead L = (Lead)so;
		if(!L.isConverted){
	        if(leadToVertriebsgebietMap.ContainsKey((String) L.get('Id')))
	            L.put('Vertriebsgebiet__c', leadToVertriebsgebietMap.get((String) L.get('Id')));
			
            system.debug('****L.Vertriebsgebiet__c = ' + L.Vertriebsgebiet__c);
			
            if(L.RecordType.Name == 'TeleSales') {

            system.debug('****L.RecordType.Name = ' + L.RecordType.Name);
                
			if((L.status == 'Präsentation – kein Interesse' || L.status == 'Schlechte Erreichbarkeit' || L.status == 'Kein Interesse' || L.status == 'kein verkaufbares Produkt') && 
	        (L.LeadSource == 'AdWords Telesales' || L.LeadSource == 'Bing Telesales' || L.LeadSource == 'Facebook Telesales' ||  
	        	L.LeadSource == 'GDN Telesales' || L.LeadSource == 'Telesales')){

                
                L.Produktauswahl__c = 'Kostenloses Produkt';    
	    		L.LeadConvertedFromPicklist__c = true;
	    		system.debug('****L.Produktauswahl__c Insert1 = ' + L.Produktauswahl__c);
	        }else if((L.status != 'Präsentation – kein Interesse' && L.status != 'Schlechte Erreichbarkeit' && L.status != 'Kein Interesse' || L.status == 'kein verkaufbares Produkt') ||
	        		(L.LeadSource != 'AdWords Telesales' && L.LeadSource != 'Bing Telesales' && L.LeadSource != 'Facebook Telesales' &&  
	        	L.LeadSource != 'GDN Telesales' && L.LeadSource != 'Telesales')){
	        	L.Produktauswahl__c = ''; 
	        	system.debug('****L.Produktauswahl__c Insert2 = ' + L.Produktauswahl__c);
	        }
                
            }

		}
		        
    } 
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        //so.put('Vertriebsgebiet__c', VertriebsgebietCalculator.calculateVertriebsgebiet(so.get('PostalCode')));
        Lead L = (Lead)so;
        Lead Lold = (Lead)oldSo;
        if(!L.isConverted){
	        if(leadToVertriebsgebietMap.ContainsKey((String) L.get('Id')))
	            L.put('Vertriebsgebiet__c', leadToVertriebsgebietMap.get((String) L.get('Id')));
	        	
            
            system.debug('****L.Vertriebsgebiet__c2 = ' + L.Vertriebsgebiet__c);
            
	        if(L.RecordType.Name == 'TeleSales') {	
	        	
            system.debug('****L.RecordType.Name2 = ' + L.RecordType.Name);
                
			if((L.status == 'Präsentation – kein Interesse' || L.status == 'Schlechte Erreichbarkeit' || L.status == 'Kein Interesse' || L.status == 'kein verkaufbares Produkt') && 
	        (L.LeadSource == 'AdWords Telesales' || L.LeadSource == 'Bing Telesales' || L.LeadSource == 'Facebook Telesales' ||  
	        	L.LeadSource == 'GDN Telesales' || L.LeadSource == 'Telesales')){

                
				L.Produktauswahl__c = 'Kostenloses Produkt';
	    		L.LeadConvertedFromPicklist__c = true;
	    		system.debug('****L.Produktauswahl__c Update1= ' + L.Produktauswahl__c);
                    
                    
                    
	        }else if((L.status != 'Präsentation – kein Interesse' && L.status != 'Schlechte Erreichbarkeit' && L.status != 'Kein Interesse' || L.status == 'kein verkaufbares Produkt') ||
	        		(L.LeadSource != 'AdWords Telesales' && L.LeadSource != 'Bing Telesales' && L.LeadSource != 'Facebook Telesales' &&  
	        	L.LeadSource != 'GDN Telesales' && L.LeadSource != 'Telesales')){
	        	L.Produktauswahl__c = ''; 
	        	system.debug('****L.Produktauswahl__c Update2= ' + L.Produktauswahl__c);
	        }
	        
	        }

        }
    }
    
    public void beforeDelete(SObject so) {   
    }
    
    public void afterInsert(SObject so) {
        Lead L = (Lead)so;
        // Use Organization Wide Address  
        
        //  !!Query und Zeile für Organization Wide Email Object einfügen!! 
        if(L.LeadSource == 'Adwords Telesales' || L.LeadSource == 'Bing Telesales' || L.LeadSource == 'Facebook Telesales' || 
            L.LeadSource == 'GDN Telesales' || L.LeadSource == 'Telesales'){
            system.debug('***L = ' + L.Id);
            Id RecTypeIdTeleSales= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TeleSales').getRecordTypeId();
            EmailTemplate templateId = [Select id from EmailTemplate where name = 'WebToLeadHTML'];
            if(/*L.RecordTypeId == RecTypeIdTeleSales && */L.email != null && L.email != ''){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {L.email};
                    email.setTargetObjectId(L.Id);
                    email.setTemplateId(templateId.Id);
                    email.setToAddresses(toAddresses );
                    email.setTargetObjectId(L.Id);
                    for(OrgWideEmailAddress owa : [select id, Address from OrgWideEmailAddress]) {
                        if(owa.Address == 'eintraege@regiohelden.de') 
                            email.setOrgWideEmailAddressId(owa.id); } 
                    Messaging.sendEmail(new Messaging.Email[] { email });
            }
        }
        Lead LeadQuered = [Select Id, OwnerId, Status, isConverted, LeadSource, Produktauswahl__c, Previous_User__r.Id 
        					from Lead where Id =: L.Id];
        if(!LeadQuered.isConverted){	
	        if((LeadQuered.status == 'Präsentation – kein Interesse' || LeadQuered.status == 'Schlechte Erreichbarkeit' || LeadQuered.status == 'Kein Interesse' || LeadQuered.status == 'kein verkaufbares Produkt') && 
	        (LeadQuered.LeadSource == 'AdWords Telesales' || LeadQuered.LeadSource == 'Bing Telesales' || LeadQuered.LeadSource == 'Facebook Telesales' ||  
	        	LeadQuered.LeadSource == 'GDN Telesales' || LeadQuered.LeadSource == 'Telesales')){
                   
	    		ConvertLeadAutomatich(LeadQuered);
	        }
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        Lead L = (Lead)so;
        Lead Lold = (Lead)oldSo;
        Lead LeadQuered = [Select Id, OwnerId, Status, LeadSource, isConverted, Produktauswahl__c, Previous_User__r.Id
        				 from Lead where Id =: L.Id];
        if(!LeadQuered.isConverted){
	        if (Lold.Get('OwnerId') != L.get('OwnerId'))
	            sObjectIds.add(L.Id);
	           
	        if((LeadQuered.status == 'Präsentation – kein Interesse' || LeadQuered.status == 'Schlechte Erreichbarkeit' || LeadQuered.status == 'Kein Interesse' || LeadQuered.status == 'kein verkaufbares Produkt') && 
	        (LeadQuered.LeadSource == 'AdWords Telesales' || LeadQuered.LeadSource == 'Bing Telesales' || LeadQuered.LeadSource == 'Facebook Telesales' ||  
	        	LeadQuered.LeadSource == 'GDN Telesales' || LeadQuered.LeadSource == 'Telesales')){
                    
	    		ConvertLeadAutomatich(L);
	        } 
        }   
    }
    
    public void afterDelete(SObject so) {
    }
    
    public void andFinally() { 
    }
    
    public void ConvertLeadAutomatich(Lead L){
    	system.debug('*****L.Produktauswahl__c = ' + L.Produktauswahl__c);
    	Lead LtoConvert = [Select id, Previous_User__r.Id, OwnerId from Lead where Id =: L.Id];
    	Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(LtoConvert.Id);
        system.debug('****L.Previous_User__r.Id = ' + L.Previous_User__r.Id);
        if(LtoConvert.Previous_User__r.Id != null)
        	Leadconvert.setOwnerId(LtoConvert.Previous_User__r.Id);
    	else
    		Leadconvert.setOwnerId(LtoConvert.OwnerId);
        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true limit 1];
        Leadconvert.setConvertedStatus('Produkt gekauft');
        //Leadconvert.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to   create an opportunity from Lead Conversion 
        Database.LeadConvertResult Leadconverts = Database.convertLead(Leadconvert);
    }
}