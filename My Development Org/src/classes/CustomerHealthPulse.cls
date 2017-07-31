public with sharing class CustomerHealthPulse {
    public void updatePulse(SObject currentObj) {
         List<CustomerHealth__c> settings = CustomerHealth__c.getAll().values();
         Account acc = (Account)currentObj;
         if((Boolean)acc.get('Customer_Health_Pulse__c')) {
             Double newValue = 0.0;
             for(CustomerHealth__c setting : settings) {
                 if(setting.Name == acc.get('Customer_Status__c')) {
                     newValue = ((Double)acc.get('Health__c')) + (Double)setting.get('Health__c');
                 }
             }
             acc.put('Last_Customer_Contact_Result__c', newValue);
             acc.put('Health__c', newValue);
             acc.put('Customer_Health_Pulse__c', false);
         }
    }
}