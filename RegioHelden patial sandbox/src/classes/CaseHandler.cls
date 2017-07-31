/**
  * CaseHandler which contains several case functions.
  * Also we handle the case trigger implementation inside 
  * this function.
  */
public class CaseHandler implements ITrigger {
    Set<Id> sObjectIds = new Set<Id>(); 
        
    // Constructor
    public CaseHandler() {
    }
   
    public void bulkBefore() {
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
        
        system.debug('****************');
        Case c = (Case) so;
        if((c.Reason == null || string.isBlank(c.Reason)) && (c.Service_Fall__c == null || string.isBlank(c.Service_Fall__c)) && c.Origin == 'Inbound - Mail')
        {
            setCaseReason(c);
            setCaseBeschwerde(c);
        }

             /*system.debug('***c.Subject = ' + c.Subject);
            system.debug('***c.SuppliedEmail = ' + c.SuppliedEmail);
            List<Account> allAccounts = [SELECT Id, Name, Email__c, Projektmanager__r.Id FROM Account WHERE Email__c =: c.SuppliedEmail];
            system.debug('****allAccounts.size()  = ' + allAccounts.size() );
            //List<Contact> allContacts = [SELECT Id, Name, Email FROM Contact WHERE Email =: c.SuppliedEmail];
            
            
            
           if(allAccounts.size() > 0)
            {
                Account firstAccount = allAccounts.get(0);

                c.OwnerId = firstAccount.Projektmanager__r.Id; 
                
                c.AccountId = firstAccount.Id;
                
                List<Contact> allContactsByAccounts = [SELECT Id FROM Contact WHERE Account.Id =: firstAccount.Id AND Email =: firstAccount.Email__c];
                
                //c.ContactId = firstAccount.Projektmanager__r.Id;
                //
                if(allContactsByAccounts != null && allContactsByAccounts.size() > 0)
                {
                    Contact firstContact = allContactsByAccounts.get(0);
                    c.ContactId = firstContact.Id;
                }
            }*/
            /*
            else
            {
                //c.Owner = '';
                List<Group> allQueues = [Select Id, Name, DeveloperName, Type FROM Group where Type = 'Queue' AND Name = 'Allgemein'];
                if(allQueues.size() > 0)
            	{
                	Group firstQueue = allQueues.get(0);
            	}
                
                c.OwnerId = allQueues.get(0).id;
            
            
            }*/
 
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
		Case c = (Case) so;
        Case Cs= [Select Id, Account.Projektmanager__r.Id from Case where Id =: so.Id];
        List<Group> QueuesGeneral = [Select Id, Name, DeveloperName, Type FROM Group where Type = 'Queue' AND Name = 'Allgemein'];
        if(c.Origin == 'Inbound - Mail')
        {
            
        	system.debug('****c.Account.Projektmanager__r.Id = ' + Cs.Account.Projektmanager__r.Id);
            if(Cs.Account.Projektmanager__r.Id != null){
            	c.OwnerId = Cs.Account.Projektmanager__r.Id;
            }else{
            	system.debug('****QueuesGeneral.size() = ' + QueuesGeneral.size());
            	if(QueuesGeneral.size()>0)
            		c.OwnerId = QueuesGeneral[0].Id;
            }
            c.Call_To_Action__c = c.OwnerId;
            system.debug('****c.OwnerId = ' + c.OwnerId);
    	}
    }
    
    public void beforeDelete(SObject so) {   
    }
    
    public void afterInsert(SObject so) {
    	UpdateCloseDateAccount((Case) so);
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        Case oldCase = (Case) oldSo;
        Case newCase = (Case) so;
        initMilestoneFinish(newCase, oldCase);
        AccountHealthto100(newCase, oldCase);
        UpdateCloseDateAccount((Case) so);
    }
    
    public void afterDelete(SObject so) {
    }
    
    public void andFinally() {
    }
    
    /**
      * Within this helper function,
      * we will set the case reason
      *
      * @param c the case to set
      *
      */
    private void setCaseReason(Case c)
    {
        //Create a email to case handler for the current case
        EmailToCaseHandler handler = new EmailToCaseHandler(c);
       
        //Get the reason and servicefall of the case by the subject
        List<String> reasonAndFall = handler.getCaseReasonBySubject();
        
        //If no reason and servicefall has been found, set the reason by the description. Description may not be empty
        if(reasonAndFall == null && c.Description != null && c.Description != '')
            reasonAndFall = handler.getCaseReasonByDescription();
        
        /**
          * If the reasonAndFall object is not null
          * we set the values
          *
          */
        if(reasonAndFall != null)
        {
            //Set the case reason and service fall
            system.debug('****Reason = ' + c.Reason);
            system.debug('***reasonAndFall = ' + reasonAndFall);
            c.Reason = reasonAndFall.get(0);
            //system.debug('******reasonAndFall.get(0) -=' + reasonAndFall.get(0));
            //system.debug('******reasonAndFall.get(1) -=' + reasonAndFall.get(1));
            c.Service_Fall__c = reasonAndFall.get(1);
            
        }
        else
        {
            //Use empty values
            c.Reason = '';
            c.Service_Fall__c = '';
        }
    }
    
    private void setCaseBeschwerde(Case c)
    {
        EmailToCaseHandler handler = new EmailToCaseHandler(c);
        
        String toCheck = c.Subject + ' ' + c.Description;
        
        c.Beschwerde__c = handler.checkForBeschwerde(toCheck);
    }
    
    /**
      * Within this function, we will execute all
      * our single functions to handle the case milestones
      * updated by the trigger
      */
    private void initMilestoneFinish(Case newCase, Case oldCase)
    {
        //The completion date, we use for all updated cases
        DateTime completionDate = System.now();
       
        if(newCase.Status == 'Wartet auf Antwort des Kunden' && oldCase.Status == 'Offen')
            CaseMilestoneUtil.completeMilestoneByName(newCase.Id, 'Erste Antwort', completionDate);
        else if(newCase.Status == 'Wartet auf interne Rückmeldung' && oldCase.Status == 'Wartet auf Antwort des Kunden')
            CaseMilestoneUtil.completeMilestoneByName(newCase.Id, 'Auf Kundenrückmeldung warten', completionDate);
        else if(newCase.Status == 'Wartet auf Antwort des Kunden' && oldCase.Status == 'Wartet auf interne Rückmeldung')
            CaseMilestoneUtil.completeMilestoneByName(newCase.Id, 'In interner Bearbeitung', completionDate);
        else
            CaseMilestoneUtil.completeAllMilestones(newCase.Id, completionDate);
    }
    private void AccountHealthto100(Case newCase, Case OldCase){
    	if(OldCase.isClosed == false && newCase.isClosed == true && newCase.CreatedFromBatch__c == true){
    		Account Acc = [Select Id, Health__c from Account where Id =: newCase.AccountId];
    		if(Acc != null){
    			Acc.Health__c = 100;
    			update Acc;
    		}
			
    	}
    }
    public void UpdateCloseDateAccount(Case c) {
    	if(c.isClosed && c.AccountId != null) {
			Account Acc = [Select Id, LastClosedTask__c from Account where id =: c.AccountId];
			if(Acc != null && (Acc.LastClosedTask__c <= c.ClosedDate || Acc.LastClosedTask__c == null)){
					Acc.LastClosedTask__c = Date.newinstance(c.ClosedDate.year(), c.ClosedDate.month(), c.ClosedDate.day());
					update Acc;
			}	 
    	}    
    }
}