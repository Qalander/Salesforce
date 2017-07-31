/**
 * Class TaskHandler
 *
 * Trigger Handler for the Task SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public class TaskHandler implements ITrigger {   
    Set<Id> sObjectIds = new Set<Id>();
    
    Set<Id> leadIdSet = new Set<Id>();
    
    // Constructor
    public TaskHandler() {

    }
   
    public void bulkBefore() {
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
    }
    
    public void beforeDelete(SObject so) {   
    }
    
    public void afterInsert(SObject so) {
    	leadIdSet.add((Id)so.get('WhoId'));
    	sObjectIds.add((Id)so.get('Id'));
    	//UpdateCloseDateAccount((Id)so.get('Id'));
    	Task T = (task)so;
		Id IdTask = (Id)so.get('Id');
		if(IdTask != null){
			String IdTaskString = (String)IdTask;
			if(IdTaskString.startsWith('00T')){
				if((t.whatID != null || t.AccountId != null) && t.Status == 'Completed' && (t.Result__c == 'Entscheider erreicht' || t.Result__c == 'Entscheider erreicht - Zweitgespräch nach Unterlagen' || t.Type == 'Email')){
					if(t.WhatId != null){
						String objectType = String.valueOf(t.WhatId.getSObjectType());
						if(objectType == 'Account'){
							UpdateCloseDateAccount(IdTask);
						}
					}else{
						UpdateCloseDateAccount(IdTask);
					}
				}
			}
		}
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
    	leadIdSet.add((Id)so.get('WhoId'));
    	sObjectIds.add((Id)so.get('Id'));
    	//UpdateCloseDateAccount((Id)so.get('Id'));
    	Task T = (task)so;
		Id IdTask = (Id)so.get('Id');
		if(IdTask != null){
			String IdTaskString = (String)IdTask;
			if(IdTaskString.startsWith('00T')){
				if((t.whatID != null || t.AccountId != null) && t.Status == 'Completed' && (t.Result__c == 'Entscheider erreicht' || t.Result__c == 'Entscheider erreicht - Zweitgespräch nach Unterlagen' || t.Type == 'Email')){
					if(t.WhatId != null){
						String objectType = String.valueOf(t.WhatId.getSObjectType());
						if(objectType == 'Account'){
							UpdateCloseDateAccount(IdTask);
						}
					}else{
						UpdateCloseDateAccount(IdTask);
					}
				}
			}
		}
    }
    
    public void afterDelete(SObject so) {
    }
    
    public void andFinally() {
    	//At first we get the profil of the logged in user profile
    	Id loggedInUserProfileId = UserInfo.getProfileId();
    	Profile profileOfLoggedInUser = [SELECT Name FROM Profile WHERE Id = :loggedInUserProfileId];
    	
    	if(profileOfLoggedInUser.Name == 'Standortleiter' || profileOfLoggedInUser.Name == 'Vertriebsmitarbeiter')
    		setNewLeadStatus();
    }
    
    /**
      * Inside this function, we will calculate and set the new lead status.
      * The new status is calculated by the activity result of the latest created
      * call task of the lead
      *
      */
    private void setNewLeadStatus()
    {
    	//We need this map to check the record type name of a lead
    	Map<Id, RecordTypeInfo> leadRecordTypeMap = Lead.sObjectType.getDescribe().getRecordTypeInfosById();
    	
    	//List of all affected leads
    	List<Lead> affectedLeads = [SELECT Id, Status, RecordTypeId,(SELECT Id, WhoId, Result__c, Type FROM Tasks WHERE Result__c != null) FROM Lead WHERE Id in :leadIdSet];
    	
    	//Leads to update
    	List<Lead> leadsToUpdate = new List<Lead>();
    	
    	/**
    	  * Itarate over each found
    	  * lead
    	  *
    	  */
    	for(Lead currentLeadToUpdate : affectedLeads)
    	{
    		String currentLeadRecordTypeName = leadRecordTypeMap.get(currentLeadToUpdate.RecordTypeID).getName();
    		
    		if(currentLeadRecordTypeName == 'Standard')
    		{
    			
    			/**
	    		  * Iterate over each task of the lead
	    		  *
	    		  */
	    		for(Task currentTask : currentLeadToUpdate.Tasks)
	    		{
	    			//We are only interested in the newest task
	    			if(sObjectIds.contains(currentTask.Id) && currentTask.type != 'Email')
	    			{
	    				String relevantTaskStatus;

	    				relevantTaskStatus = currentTask.Result__c;
	    				
	    				//The new status of the lead
	    				String newLeadStatus = calculateNewLeadStatus(relevantTaskStatus);
	    				
	    				//The current statuc of the lead
	    				String currentLeadStatus = currentLeadToUpdate.Status;
	    				/**
	    				  * This is a special condition. If the old leadstatus is 'Entscheider erreicht' and the
	    				  * new status would be 'Kontaktiert', we will NOT update the status
	    				  *
	    				  */
	    				if(!(currentLeadStatus == 'Entscheider erreicht' && newLeadStatus == 'Kontaktiert'))
	    					currentLeadToUpdate.Status = calculateNewLeadStatus(currentTask.Result__c);
	    			}		
	    		}
	    		
	    		//Mark the lead to update
	    		leadsToUpdate.add(currentLeadToUpdate);
	    	}
	    	
	    	//Update the leads
	    	if(leadsToUpdate.size() > 0)
	    		update leadsToUpdate;	
    		}		
    }
    
    /**
      * Inside this method, we will calcuilate the new lead status depending
      * on the given task status.
      *
      * @param taskStatus The activity result of the new task
      *
      * @return The new lead status
      */
    private String calculateNewLeadStatus(String taskStatus)
    {
    	//Set of all activity result which are equal to the lead status to set
    	Set<String> sameAsParameter = new Set<String>{'Entscheider erreicht', 'kein Interesse / WV möglich',
    													'kein Interesse / nicht mehr anrufen'};
    													
    	//Set of all activity results which will set the lead status to 'Kontaktiert'				
    	Set<String> statusToKontaktiert = new Set<String>{'nicht erreicht - Entscheider nicht bekommen', 'nicht erreicht - Anrufbeantworter',
    														'nicht erreicht - Besetzt', 'nicht erreicht - niemand anwesend'};

		
    	/**
    	  * Calculate the lead status depending on the given
    	  * task status
    	  *
    	  */
    	if(sameAsParameter.contains(taskStatus))
    		return taskStatus;
    	else if(statusToKontaktiert.contains(taskStatus))
    		return 'Kontaktiert';
    	else if(taskStatus == 'Entscheider erreicht - Zweitgespräch nach Unterlagen')
    		return 'Zweitgespräch nach Unterlagen';
    	else if(taskStatus == 'unqualifiziert')
    		return 'unqualifiziert / nicht angehen';
    	else
    		return 'unqualifiziert / Anschluss nicht erreichbar';
    }
    
    @future 
	public static void UpdateCloseDateAccount(Id IdTask) {
		if(IdTask != null){
			String IdTaskString = (String)IdTask;
			if(IdTaskString.startsWith('00T')){
			task t = [Select Id, Type, AccountId, whatID, Status, ActivityDate, Result__c 
				from Task where id =: IdTask];
				Id AccountId;
				if(t.AccountId != null){
					AccountId = t.AccountId;
				}else{
					AccountId = t.WhatId;
				}
				Account Acc = [Select Id, LastClosedTask__c from Account where id =: AccountId];
				system.debug('***t.Status = ' + t.Status);
				system.debug('***Acc.LastClosedTask__c = ' + Acc.LastClosedTask__c);
				system.debug('***t.ActivityDate = ' + t.ActivityDate);
				if(Acc != null && (Acc.LastClosedTask__c <= t.ActivityDate || Acc.LastClosedTask__c == null)){
					Acc.LastClosedTask__c = t.ActivityDate;
					if(t.Status == 'Completed') {
						Acc.Health__c = 100;
					}
					update Acc;
				}
			}
		}
	}
}