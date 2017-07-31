/**
 * Class AccountHandler
 *
 * Trigger Handler for the Account SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class AccountHandler implements ITrigger {       
    Set<Id> sObjectIds = new Set<Id>();
    
    Map<String, String> accountToVertriebsgebietMap = new Map<String, String>();
    
    // Constructor
    public AccountHandler() {
    }
   
    public void bulkBefore() {
    	if(Trigger.isInsert || Trigger.isUpdate)
    	{
    		for(sObject account : Trigger.new)
    		{
    			String vertiebsgebiet = (String) VertriebsgebietCalculator.calculateVertriebsgebiet(account.get('BillingPostalCode'));
    			accountToVertriebsgebietMap.put((String)account.get('Id'), vertiebsgebiet);
    		}
    	}
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
        //so.put('Vertriebsgebiet__c', VertriebsgebietCalculator.calculateVertriebsgebiet(so.get('BillingPostalCode')));
        if(accountToVertriebsgebietMap.ContainsKey((String) so.get('Id')))
        	so.put('Vertriebsgebiet__c', accountToVertriebsgebietMap.get((String) so.get('Id')));
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        //Set the Vertriebsgebiet
        //so.put('Vertriebsgebiet__c', VertriebsgebietCalculator.calculateVertriebsgebiet(so.get('BillingPostalCode')));
        if(accountToVertriebsgebietMap.ContainsKey((String) so.get('Id')))
        	so.put('Vertriebsgebiet__c', accountToVertriebsgebietMap.get((String) so.get('Id')));
        
        CustomerHealthPulse chp = new CustomerHealthPulse();
        chp.updatePulse(so);
    }
    
    public void beforeDelete(SObject so) {   
    }
    
    public void afterInsert(SObject so) {
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        if (oldSo.Get('OwnerId') != so.get('OwnerId'))
            sObjectIds.add(so.Id);
    }
    
    public void afterDelete(SObject so) {
    }
    
    public void andFinally() {
    }
}