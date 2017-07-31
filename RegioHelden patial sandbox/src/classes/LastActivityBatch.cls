/**
 * Batch Job for updating last activity field of every account and lead
 */
public with sharing class LastActivityBatch implements DataBase.Batchable<sObject>, Database.Stateful{
	
	private LastActivityManager lam = new LastActivityManager();
	private Integer accountLeadSelection = -2; 
	
	/**
	 * Querys every account and lead
	 */
	public Iterable<sObject> start(Database.BatchableContext bc) {
		/**
		 * Query Tasks/Leads to Update
		 * LIMIT is set to 20k to avoid hitting governor limits
		 */
		List<sObject> accounts = [SELECT Id FROM Account WHERE LastModifiedDate < :DateTime.now().addHours(accountLeadSelection) LIMIT 10000];
		List<sObject> leads = [SELECT Id FROM Lead WHERE LastModifiedDate < :DateTime.now().addHours(accountLeadSelection) LIMIT 10000];
		List<sObject> accountsLeads = new List<sObject>();
		accountsLeads.addAll(accounts);
		accountsLeads.addAll(leads);
		return accountsLeads;
	}
	
	/**
	 * Executes last activity update method for scope
	 * @param scope Accounts and leads for update
	 */
	public void execute(DataBase.BatchableContext bc, List<sObject> scope) {
		List<String> ids = new List<String>();
		for (sObject current : scope) {
			ids.add((String) current.get('id'));
		}
		List<sObject> tasks = [SELECT id, WhatId, WhoId, ActivityDate, IsRecurrence FROM Task WHERE isdeleted = false AND (WhatId IN :ids OR WhoId IN :ids) ORDER BY ActivityDate DESC LIMIT 10000];
		List<sObject> events = [SELECT id, WhatId, WhoId, ActivityDate, IsRecurrence FROM Event WHERE isdeleted = false AND (WhatId IN :ids OR WhoId IN :ids) ORDER BY ActivityDate DESC LIMIT 10000];
		List<sObject> tasksAndEvents = new List<sObject>();
		tasksAndEvents.addAll(tasks);
		tasksAndEvents.addAll(events);
		lam.updateLastActivity(tasksAndEvents, false);
	}
	
	public void finish(DataBase.BatchableContext bc) {}
	
	public void setAccountLeadSelection(Integer accountLeadSelection) {
		this.accountLeadSelection = accountLeadSelection;
	}

}