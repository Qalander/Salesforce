public with sharing class CustomerHealthManager {
    public void updateLastCustomerContact(List<sObject> objects, boolean isDelete) {
        Set<String> Ids = new Set<String>();
        
        for (sObject currentObject : objects) {
            if(currentObject.get('WhatId') != null)
                Ids.add((String)currentObject.get('WhatId'));
        }
        
        
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Last_Customer_Contact__c, Last_Customer_Contact_Id__c, Last_Customer_Contact_Result__c, Health__c FROM Account WHERE Id IN :Ids]);
        updateValues(objects, accounts, isDelete);
    }
    
    private void updateValues(List<sObject> objects, Map<Id, Account> accounts, boolean isDelete) {
        //Custom Settings
        List<CustomerHealth__c> settings = CustomerHealth__c.getAll().values();
        Map<Id, Account> toUpdateAccounts = new Map<Id, Account>();
        for (sObject currentTask : objects) {
            if(currentTask.get('RecordTypeId') == '012w000000072Wp') { // Record Type Retrospective (Rückblickgespräch)
                String accountId = (String)currentTask.get('WhatId');
                if (!String.isEmpty(accountId) && accounts.get(accountId) != null && accountId.substring(0,3) == '001') {
                    Account account = accounts.get(accountId);
                    if(currentTask.get('IsRecurrence') == false) {
                        if(account.get('Last_Customer_Contact_Id__c') == currentTask.get('Id')) {
                            if(isDelete) {
                            	List<Task> tasks = [SELECT Id, ActivityDate FROM Task WHERE WhatId = :accountId  AND RecordTypeId = '012w000000072Wp' ORDER BY ActivityDate DESC LIMIT 1];
                                
                                if(tasks.isEmpty()) {
	                                account.put('Last_Customer_Contact__c', null);
	                                account.put('Last_Customer_Contact_Id__c', null);
	                            }
	                            else {
	                                Task retrospective = (Task)tasks[0];
	                                if(retrospective != null) {
	                                    account.put('Last_Customer_Contact__c', retrospective.get('ActivityDate'));
	                                    account.put('Last_Customer_Contact_Id__c', retrospective.get('Id'));
	                                }
                                }
                                Double oldValue = (Double)account.get('Last_Customer_Contact_Result__c');
                                account.put('Health__c', oldValue);
                                
                            }
                            else {
                                account.put('Last_Customer_Contact__c', (Date)currentTask.get('ActivityDate'));
                                Double newValue = 0;
                                Double oldValue = (Double)account.get('Last_Customer_Contact_Result__c');   
                                for(CustomerHealth__c setting : settings) {
                                    if(setting.Name == currentTask.get('Status')) {
                                        newValue = oldValue + (Double)setting.get('Health__c');
                                    }
                                }
                                if(newValue  > 100)
                                    newValue = 100;
                                account.put('Health__c', newValue);
                            }
                        }
                        else if((Date)account.get('Last_Customer_Contact__c') == null || (((Date)currentTask.get('ActivityDate')).daysBetween((Date)account.get('Last_Customer_Contact__c'))) < 0) {
                            account.put('Last_Customer_Contact__c', (Date)currentTask.get('ActivityDate'));
                            account.put('Last_Customer_Contact_Id__c', (String)currentTask.get('Id'));
                            account.put('Last_Customer_Contact_Result__c', account.get('Health__c'));
                            Double newValue = 0;
                            for(CustomerHealth__c setting : settings) {
                                if(setting.Name == currentTask.get('Status')) {
                                    newValue = ((Double)account.get('Health__c')) + (Double)setting.get('Health__c');
                                }
                            }
                            if(newValue  > 100)
                                newValue = 100;
                            account.put('Health__c', newValue);                   
                        }
                    } 
                    toUpdateAccounts.put((String)account.get('Id'), account);          
                }
            }
        }
        update toUpdateAccounts.values();
    }
}