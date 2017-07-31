public class CampaignHandler 
{	
	public void updateAllCampaigns()
	{
		//A set of ids we need
		Set<Id> leadIds = new Set<Id>();
		Set<Id> contactIds = new Set<Id>();
		Set<Id> accountIds = new Set<Id>();

		//Get all Campaigns and its Campaign Members
		List<Campaign> campaignList = [SELECT Id, Name, EndDate, StartDate, Anzahl_Abschluesse__c, Vertriebsleistung_der_Abschluesse__c, (SELECT Id, Status, LeadId, ContactId, CompanyOrAccount FROM CampaignMembers), (SELECT Id, StageName, Vertriebsleistung__c, CloseDate FROM Opportunities WHERE (StageName = 'Geschlossen und gewonnen' OR StageName = 'Auftrag genehmigt - Kunde nicht erreicht' OR  StageName = 'Auftrag genehmigt')) FROM campaign];
		
		//List of Campaigns we want to update
		List<Campaign> toUpdate = new List<Campaign>();
		
		/**
		  * Iterate over each campaign
		  *
		  */
		for(Campaign c : campaignList)
		{
			
			/**
			  * Iterate over each campaign member
			  *
			  */
			for(CampaignMember cm : c.CampaignMembers)
			{
				/**
				  * Check if the campaign has a contact id,
				  * if so we dont watch for leads anymore.
				  * If we have no contact id, we watch for lead id
				  *
				  */
				if(cm.ContactId != null)
				{
					contactIds.add(cm.ContactId);
				}
				else if(cm.LeadId != null)
				{
					//Add the leadId fof the current campaign member to the set
					leadIds.add(cm.Leadid);
				}
				
				
			}
		}
		
		//Build the lead map
		Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Name, ConvertedAccountId, (SELECT Id, isClosed, Type, CreatedDate, Result__c, Wiedervorlage_automatisch_geschlossen__c FROM Tasks) FROM Lead WHERE Id IN :leadIds]);
		
		//Build the contact map
		Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Name, Account.Id, Account.Name, (SELECT Id, isClosed, CreatedDate, Type, Result__c, Wiedervorlage_automatisch_geschlossen__c FROM Tasks) FROM Contact WHERE Id IN :contactIds]);
		
		/**
		  * Iterate over each contact value inside the map
		  * to build the account id set
		  *
		  */
		for(Contact contact : contactMap.values())
		{
			accountIds.add(contact.Account.Id);
		}
		
		//The account map
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, (SELECT Id, Termin_Ergebnis__c, CreatedDate FROM Events) FROM Account WHERE Id IN :accountIds]);
	
		
		/**
		  * Iterate over each Campaign
		  */
		for(Campaign c : campaignList)
		{
			//Retrive the updated Campaign
			toUpdate.add(getUpdatedCampaign(c, leadMap, contactMap, accountMap));
		}
		
		//Update all Campaigns
		update toUpdate;
	}

    /**
      * Inside this function, we will calculate the amount of tasks
      * which are brutto calls
      *
      * @param tasksToFilter All tasks of a lead
      *
      * return bruttoCallSize The amount of relevant tasks
      */	
	private Integer calculateBruttoCalls(List<Task> tasksToFilter, Campaign campaignToUpdate)
	{
		//Default value
		Integer bruttoCallsSize = 0;
		
		/**
		  * Iterate over each task
		  *
		  */
		for(Task t : tasksToFilter)
		{
			/**
			  * Condition for brutto calls
			  *
			  */
			if(t.isClosed && t.type != 'Email' && checkDateInRange(t.CreatedDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate) && t.Wiedervorlage_automatisch_geschlossen__c == false)
				bruttoCallsSize++;
		}
		
		return bruttoCallsSize;
	}
	
	/**
      * Inside this function, we will calculate the amount of tasks
      * which are netto calls
      *
      * @param tasksToFilter All tasks of a lead
      *
      * return bruttoCallSize The amount of relevant tasks
      */
	private Integer calculateNettoCalls(List<Task> tasksToFilter, Campaign campaignToUpdate)
	{
		//Default value
		Integer nettoCallsSize = 0;
		
		Set<String> possibleNettoReasons = new Set<String>{'Entscheider erreicht', 'Entscheider erreicht - Zweitgespräch nach Unterlagen', 
												'kein Interesse / WV möglich'};
		
		/**
		  * Iterate over each task
		  *
		  */
		for(Task t : tasksToFilter)
		{
			/**
			  * Condition for brutto calls
			  *
			  */
			if(t.isClosed && t.type != 'Email'&& possibleNettoReasons.contains(t.Result__c) && checkDateInRange(t.CreatedDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate) && t.Wiedervorlage_automatisch_geschlossen__c == false)
				nettoCallsSize++;
		}
		
		return nettoCallsSize;
	}
	
	/**
      * Inside this function, we will calculate the amount of tasks
      * which are besuche
      *
      * @param eventsToFilter All events of a account
      *
      * return besucheSize The amount of relevant tasks
      */
	private Integer calculateBesuche(List<Event> eventsToFilter, Campaign campaignToUpdate)
	{
		/**
		  * Set of unwanted reasons
		  *
		  */
		Set<String> invalidBesuchReasons = new Set<String>{'nicht stattgefunden - im Vorfeld abgesagt', 'nicht stattgefunden - AP nicht anwesend', 
												'nicht stattgefunden - Terminstorno', 'null'};
		
		Integer besucheSize = 0;
		
		/**
		  * Iterate over each task
		  *
		  */
		for(Event e : eventsToFilter)
		{
			System.debug(e.Termin_Ergebnis__c);
			/**
			  * Condition for besuche
			  *
			  */
			if(e.Termin_Ergebnis__c != null && !invalidBesuchReasons.contains(e.Termin_Ergebnis__c) && checkDateInRange(e.CreatedDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate))
				besucheSize++;
		}
		
		return besucheSize;
	}
	
	/**
      * Inside this function, we will calculate the amount of tasks
      * which are Termine
      *
      * @param eventsToFilter All Events of a account
      *
      * return termineSize The amount of relevant tasks
      */
	private Integer calculateTermine(List<Event> eventsToFilter, Campaign campaignToUpdate)
	{
		Integer termineSize = 0;
		
		/**
		  *Iterate over each event
		  *
		  */
		for(Event e : eventsToFilter)
		{
			/**
			  * Condition for termine
			  *
			  */
			if(checkDateInRange(e.CreatedDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate))
				termineSize++;
		}
		
		return termineSize;
	}
	
	/**
	  * Within this function, we calculate the vertiebsleistungen of
	  * all opportunities of an campaign
	  *
	  * @param opportunitiesToCalculate All opportunities of a campaign
	  *
	  * @return vertiebsleistungAmount The whole amount of all vertriebsleistungen
	  *
	  */
	private Decimal calculateVertriebsleistungNachAbschluesse(List<Opportunity> opportunitiesToCalculate, Campaign campaignToUpdate)
	{
		Decimal vertiebsleistungAmount = 0;
		
		for(Opportunity o : opportunitiesToCalculate)
		{
			if(checkDateInRange(o.CloseDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate) && o.StageName == 'Geschlossen und gewonnen')
				vertiebsleistungAmount+= o.Vertriebsleistung__c;
				system.debug('############ Campaign ID: ' + campaignToUpdate.Id);
				system.debug('Vertriebsleistung: ' + vertiebsleistungAmount);
		}
		
		return vertiebsleistungAmount;
	}
	
	private Integer calculateAnzahlAbschluesse(List<Opportunity> opportunitiesToCalculate, Campaign campaignToUpdate)
	{
		Integer anzahlAbschluesse = 0;
		
		for(Opportunity o : opportunitiesToCalculate)
		{
			if(checkDateInRange(o.CloseDate, campaignToUpdate.StartDate, campaignToUpdate.EndDate) && o.StageName == 'Geschlossen und gewonnen')
				anzahlAbschluesse++;
				system.debug('############ Campaign ID: ' + campaignToUpdate.Id);
				system.debug('Anzahl Abschlüsse: ' + anzahlAbschluesse);
		}
		
		return anzahlAbschluesse;
	}
	
	/**
	  * This function will update a campaigns values and returns it.
	  *
	  * @param campaignToUpdate The campaign to update the values
	  * @param leadMap A Map of all leads, to find the depended campaign
	  */
	private Campaign getUpdatedCampaign(Campaign campaignToUpdate, Map<Id, Lead> leadMap, Map<Id, Contact> contactMap, Map<Id, Account> accountMap)
	{
		/**
		  * Variables for the new field values
		  */
		Integer bruttoCalls = 0;
		Integer nettoCalls = 0;
		Integer besuche = 0;
		Integer termine = 0; 
		Decimal vertiebsleistungAmount = 0;
		
		//Set the value of all vertriebsleitungen
		campaignToUpdate.Anzahl_Abschluesse__c = calculateAnzahlAbschluesse(campaignToUpdate.Opportunities, campaignToUpdate);
		campaignToUpdate.Vertriebsleistung_der_Abschluesse__c = calculateVertriebsleistungNachAbschluesse(campaignToUpdate.Opportunities, campaignToUpdate);
		
		/**
		  * Iterate over each campaignMember of the current
		  * campaign
		  */
		for(CampaignMember cm : campaignToUpdate.CampaignMembers)
		{
			//The current lead
			Lead ld = leadMap.get(cm.LeadId);
			//Check if the lead is not equals to null
			if(ld != null)
			{
				System.debug('Berechne Calls');
				/**
				  * Update all the fields with the tasks and events
				  * of the current lead
				  */
				bruttoCalls += calculateBruttoCalls(ld.Tasks, campaignToUpdate);
				nettoCalls += calculateNettoCalls(ld.Tasks, campaignToUpdate);
				
				//Account convertedLeadAccount = accountMap.get(ld.ConvertedAccountId);
			}
			
			//We also check for a contact
			Contact c = contactMap.get(cm.ContactId);
			
			if(c != null)
			{
				bruttoCalls += calculateBruttoCalls(c.Tasks, campaignToUpdate);
				nettoCalls += calculateNettoCalls(c.Tasks, campaignToUpdate);
				
				//Get the account of the contact
				Account a = accountMap.get(c.Account.Id);
				
				if(a != null)
				{
					//Update besuche by the events of the current account
					besuche += calculateBesuche(a.Events, campaignToUpdate);
					termine += calculateTermine(a.Events, campaignToUpdate);
				}
			}
		}
		
		/**
		  * Set the campaign values
		  *
		  */
		campaignToUpdate.Brutto_Calls__c = bruttoCalls;
		campaignToUpdate.Netto_Calls__c = nettoCalls;
		campaignToUpdate.Besuche__c = besuche;
		campaignToUpdate.Termine__c = termine;
		
		//return the campaign
		return campaignToUpdate;
	}
	
	private boolean checkDateInRange(DateTime dateTimeToCheck, Date startDateRange, Date endDateRange)
	{
		Date dateToCheck = Date.newinstance(dateTimeToCheck.year(), dateTimeToCheck.month(), dateTimeToCheck.day());
		
		if(startDateRange <= dateToCheck && dateToCheck <= endDateRange){
			return true;
		}	
		return false;
	}
	
}