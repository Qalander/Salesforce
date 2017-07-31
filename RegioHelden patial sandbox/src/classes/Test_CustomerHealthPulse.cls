@isTest
private class Test_CustomerHealthPulse {
    
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
            type__c = '1'
        );
        
        insert c;
        CustomerHealth__c s = new CustomerHealth__c(
            Name = 'Neustarter',
            Health__c = -8
        );
        insert s;
    }
    
    @isTest
    private static void testCustomerHealthPulse() {        
        Account acc = [SELECT Id,AdWords_Start_Date__c,Customer_Status__c FROM Account WHERE Name='This is a unique Account name' LIMIT 1];
        Contract__c con = [SELECT Id,started_date__c FROM Contract__c WHERE Name='This is a unique contract' LIMIT 1];
        
        System.assertEquals(null, acc.AdWords_Start_Date__c);
        System.assertEquals('Kein AdWords Kunde', acc.Customer_Status__c);
    
        Test.startTest();
        
        con.started_date__c = Date.today().addDays(-4);
        update con;
        
        acc = [SELECT Id,AdWords_Start_Date__c,Customer_Status__c,Health__c FROM Account WHERE Id = :acc.Id]; 
        System.assertEquals(Date.today().addDays(-4), acc.AdWords_Start_Date__c);
        System.assertEquals('Neustarter', acc.Customer_Status__c);
        System.assertEquals(100, acc.Health__c);
        
        acc.Customer_Health_Pulse__c = true;
        update acc;
        
        List<CustomerHealth__c> settings = CustomerHealth__c.getAll().values();
        
        acc = [SELECT Id,Health__c,Customer_Health_Pulse__c,Customer_Status__c,Last_Customer_Contact_Result__c FROM Account WHERE Id = :acc.Id]; 
        Double newValue = 0.0;
        for(CustomerHealth__c setting : settings) {
            if(setting.Name == acc.Customer_Status__c) {
                newValue = setting.Health__c;
            }
        }
        System.assertEquals(false, acc.Customer_Health_Pulse__c );
        System.assertEquals(100 + newValue, acc.Health__c);
        System.assertEquals(acc.Health__c, acc.Last_Customer_Contact_Result__c );
        
        Test.stopTest();
    }

}