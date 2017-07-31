/**
 * Class contains methods for updating last activity field of accounts and leads
 * #--------------------------------------------#
 * Updates:
 * 06.10.2016 - Daniel Garus
 * *Restructured methods to improve flow readability
 * 10.10.2016 - Daniel Garus
 * *Added check in updateLastActivityDate to ignore the record if the current user doesn't have access to it
 * *Added new field Last_Activity_Owner_Past / Future which gets updated
 * 27.10.2016 - Daniel Garus
 * *Added Check, if future activity date is lower then past activity date
 */
public with sharing class LastActivityManager {
	
	/**
	 * Wrapper called for updating last Activity from Scheduler or Trigger insert
	 * @param objects task/event objects
	 * @param isDelete Method called from a trigger delete?
	 */
	public void updateLastActivity(List<sObject> objects, boolean isDelete) {
		Set<String> Ids = retrieveLeadAndAccountIds(objects);
		// Query accounts and leads to update and add them to a single list
		Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Account WHERE Id IN :Ids]);
		Map<Id, Lead> leads = new Map<ID, Lead>([SELECT Id, Last_Activity_Date_Past__c, Last_Activity_Past__c, Last_Activity_ID_Past__c, Last_Activity_Date_Future__c, Last_Activity_Future__c, Last_Activity_ID_Future__c FROM Lead WHERE Id IN :Ids]);
		updateLastActivityDate(objects, accounts, leads, isDelete);
	}	
	
	/**
	 * Retrieve Leads/Accounts associated with tasks/events
	 * @param objects Tasks/Events
	 * @return Set<String> Set of possible account-/lead ids
	 */
	private Set<String> retrieveLeadAndAccountIds(List<sObject> objects) {
		Set<String> Ids = new Set<String>();
		// Get ids of accounts and leads to update
		for (sObject currentObject : objects) {
			if(currentObject.get('WhatId') != null)
				Ids.add((String)currentObject.get('WhatId'));
			if(currentObject.get('WhoId') != null)
				Ids.add((String)currentObject.get('WhoId'));
		}
		return Ids;
	}
	
	/**
	 * Update Last Activity Date of accounts leads associated by the tasks/events
	 * @param objects changed or new tasks or events
	 * @param accounts accounts associated by these tasks and events
	 * @param leads leads associated by these tasks and events
	 * @param isDelete Method called from a trigger delete?
	 */
	private void updateLastActivityDate(List<sObject> objects, Map<Id, Account> accounts, Map<Id, Lead> leads, boolean isDelete) {
		Map<Id, Account> toUpdateAccounts = new Map<Id, Account>();
		Map<Id, Lead> toUpdateLeads = new Map<Id, Lead>();
				
		// Iterate over all tasks/events
		for (sObject currentObject : objects) {
			// Get account and/or lead
			String accountId = (String)currentObject.get('WhatId');
			String leadId = (String)currentObject.get('WhoId');		
			// Is an account associated by the current task/event?
			if (!String.isEmpty(accountId) && accounts.get(accountId) != null) {
				Account account = accounts.get(accountId);
				doUpdateLastActivity(account, currentObject, toUpdateAccounts, isDelete);				
			}
			// Same for leads
			if (!String.isEmpty(leadId) && leads.get(leadId) != null) {
				Lead lead = leads.get(leadId);
				doUpdateLastActivity(lead, currentObject, toUpdateLeads, isDelete);
			}
		}
		try {
			update toUpdateLeads.values();
			update toUpdateAccounts.values();
		}
		catch (Exception ex) {
			System.Debug('Exception on Update');
		}
	}
	
	/**
	 * Updates the LastActivity for the given account/lead
	 * @param accountLead Account- or Lead-Object
	 * @param taskEvent Task-/Event-Object
	 * @param toUpdate Maps of Accounts/Leads to Update
	 * @param isDelete Method called from a trigger delete?
	 */
	private void doUpdateLastActivity(sObject accountLead, sObject taskEvent, Map<Id, sObject> toUpdate, boolean isDelete) {		
        // Ignore Recurrance base activity
        if (taskEvent.get('IsRecurrence') == false) {
        	
        	String activityId = (String)taskEvent.get('id');
        	
	        String pastDateField = 'Last_Activity_Date_Past__c';
	        String pastIdField = 'Last_Activity_ID_Past__c';
	        String pastOwnerField = 'Last_Activity_Owner_Past__c';
	        
	        String futureDateField = 'Last_Activity_Date_Future__c';
	        String futureIdField = 'Last_Activity_ID_Future__c';
	        String futureOwnerField = 'Last_Activity_Owner_Future__c';
	        
	        String DateField;
	        String IdField;
	        String OwnerField;
	        
	        Boolean isPast = false;
	        Date previousDate = null;
        	//Check if the Activity was already used in the record
        	
        	
        	//Only calculate if ActivityDate is set
        	if(taskEvent.get('ActivityDate') != null && !isDelete) {
        		Date actDate = (Date)taskEvent.get('ActivityDate');
        		
				//Check wether to use the past fields or the future fields        		
	        	isPast = (Date.today().daysBetween(actDate)) < 0;
	        	
	        	DateField = isPast ? pastDateField : futureDateField;
	        	IdField = isPast ? pastIdField : futureIdField;
	        	OwnerField = isPast ? pastOwnerField : futureOwnerField;
	        	
	        	if (activityId.equals((String)accountLead.get(futureIdField))) {
                	clearSelectedFields(accountLead, 'Future');
	        	} else if (activityId.equals((String)accountLead.get(pastIdField))) {
                	clearSelectedFields(accountLead, 'Past');
	        	}
	        	
	        	if (accountLead.get(DateField) == null || 
	        	(isPast && calculateDayRange(Date.today(), actDate) < calculateDayRange(Date.today(), (Date)accountLead.get(DateField))) || 
	        	(!isPast && calculateDayRange(Date.today(), actDate) >= calculateDayRange(Date.today(), (Date)accountLead.get(DateField)))) {
                	accountLead.put(DateField, actDate);
                	accountLead.put(IdField, activityId);
                	accountLead.put(OwnerField, (String)taskEvent.get('OwnerId'));
            	}
            	if(isPast && accountLead.get(futureDateField) != null && ((Date)accountLead.get(DateField)).daysBetween((Date)accountLead.get(futureDateField)) <= 0) {
                	clearSelectedFields(accountLead, 'Future');
            	}
        	} else if(isDelete) {
        		if((String)accountLead.get(futureIdField) == activityId)
                	clearSelectedFields(accountLead, 'Future');
               	if((String)accountLead.get(pastIdField) == activityId)
                	clearSelectedFields(accountLead, 'Past');
        	}
        	
        	toUpdate.put((String)accountLead.get('Id'), accountLead);        	
        }
	}
	
	/**
	 * Sets the Future or Past Fields to null
	 */
	private void clearSelectedFields(sObject accountLead, String futurePast) {
		accountLead.put('Last_Activity_Date_' + futurePast + '__c', null);
        accountLead.put('Last_Activity_ID_' + futurePast + '__c', null);
        accountLead.put('Last_Activity_Owner_' + futurePast + '__c', null);
	}
	
	/**
	 * Calculates day range between two dates
	 * @param date1 Date 1
	 * @param date2 Date 2
	 * @return Integer Time difference in days between the two dates
	 */
	private Integer calculateDayRange(Date date1, Date date2) {
		return Math.abs(date1.daysBetween(date2)); 
	}
}