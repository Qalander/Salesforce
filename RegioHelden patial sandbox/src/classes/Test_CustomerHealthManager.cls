@isTest
public class Test_CustomerHealthManager {
    @testSetup private static void setup() {
        Account a = new Account(
            name = 'This is a unique Account name',
            Phone = 'ka',
            Health__c = 100
        );
        insert a;
        Contract__c c = new Contract__c(
            name = 'This is a unique contract',
            Account__c = a.Id,
            product_id__c = '0',
            type__c = '1',
            started_date__c = Date.today().addDays(-4)
        );
        
        insert c;
        CustomerHealth__c s = new CustomerHealth__c(
            Name = 'Kunde zufrieden',
            Health__c = 100
        );
        insert s;
        s = new CustomerHealth__c(
            Name = 'Kunde unzufrieden',
            Health__c = -10
        );
        insert s;
        s = new CustomerHealth__c(
            Name = 'Offen',
            Health__c = 0
        );
        insert s;
    }
    
    @isTest
    public static void testCustomerHealthManager() {
        Account acc = [SELECT Id, Health__c FROM Account WHERE Name='This is a unique Account name' LIMIT 1];
            
        Test.startTest();
        
        System.assertEquals(100, acc.Health__c);
        
        Task retrospective = new Task(
            Subject = 'Rückblickgespräch',
            RecordTypeId = '012w000000072Wp',
            WhatId = acc.id,
            ActivityDate = Date.today().addDays(-2),
            Status = 'Offen'
        );
        insert retrospective;
        
        acc = [SELECT Id,Health__c,Last_Customer_Contact__c,Last_Customer_Contact_Id__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(100, acc.Health__c);
        System.assertEquals(retrospective.ActivityDate , acc.Last_Customer_Contact__c);
        System.assertEquals(retrospective.Id, acc.Last_Customer_Contact_Id__c );

        retrospective.Status = 'Kunde unzufrieden';
        update retrospective;
                        
        List<CustomerHealth__c> settings = CustomerHealth__c.getAll().values();
        
        acc = [SELECT Id,Health__c,Last_Customer_Contact_Result__c FROM Account WHERE Id = :acc.Id];
        Double newValue = 0.0;
        for(CustomerHealth__c setting : settings) {
            if(setting.Name == retrospective.Status) {
                newValue = setting.Health__c;
            }
        }
        System.assertEquals(100 + newValue, acc.Health__c);
        System.assertEquals(acc.Health__c - newValue, acc.Last_Customer_Contact_Result__c );
        Double tempHealth = acc.Health__c;
        
        Task retrospective2 = new Task(
            Subject = 'Rückblickgespräch',
            RecordTypeId = '012w000000072Wp',
            WhatId = acc.id,
            ActivityDate = Date.today(),
            Status = 'Kunde zufrieden'
        );
        insert retrospective2;
        
        acc = [SELECT Id,Health__c,Last_Customer_Contact_Result__c,Last_Customer_Contact__c,Last_Customer_Contact_Id__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(retrospective2.ActivityDate , acc.Last_Customer_Contact__c);
        System.assertEquals(retrospective2.Id, acc.Last_Customer_Contact_Id__c );
        
        newValue = 0.0;
        for(CustomerHealth__c setting : settings) {
            if(setting.Name == retrospective2.Status) {
                newValue = setting.Health__c;
            }
        }
        
        System.assertEquals(tempHealth, acc.Last_Customer_Contact_Result__c);
        System.assertEquals(100, acc.Health__c); //Customer Health cannot go over 100
        
        delete retrospective2;
        
        acc = [SELECT Id,Health__c,Last_Customer_Contact_Result__c,Last_Customer_Contact__c,Last_Customer_Contact_Id__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(retrospective.Id, acc.Last_Customer_Contact_Id__c);
        System.assertEquals(retrospective.ActivityDate , acc.Last_Customer_Contact__c);
        newValue = 0.0;
        for(CustomerHealth__c setting : settings) {
            if(setting.Name == retrospective.Status) {
                newValue = setting.Health__c;
            }
        }
        System.assertEquals(tempHealth, acc.Health__c);
        System.assertEquals(tempHealth, acc.Last_Customer_Contact_Result__c );
                
        delete retrospective;
        
        acc = [SELECT Id,Health__c,Last_Customer_Contact_Result__c,Last_Customer_Contact__c,Last_Customer_Contact_Id__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(null, acc.Last_Customer_Contact_Id__c);
        System.assertEquals(null , acc.Last_Customer_Contact__c);
        newValue = 0.0;
        for(CustomerHealth__c setting : settings) {
            if(setting.Name == retrospective.Status) {
                newValue = setting.Health__c;
            }
        }
        System.assertEquals(90, acc.Health__c); //because deleting the second record cannot retrieve the first health
        System.assertEquals(90, acc.Last_Customer_Contact_Result__c );
        
        Test.stopTest();
    }

}