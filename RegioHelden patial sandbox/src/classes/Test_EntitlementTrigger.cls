@isTest
private class Test_EntitlementTrigger {
    
    @testSetup private static void setup() {
        
		Account a = new Account(
        	name = 'Void company',
        	Phone = 'ka'
        );
        
        insert a;
                
        List<Entitlement> ents = new List<Entitlement>{
            new Entitlement(
        	Name = 'Universal Entitlement',
        	AccountId = a.Id
        	),
            new Entitlement(
        	Name = 'Bogus Entitlement',
        	AccountId = a.Id
            )
         };
         insert ents;
    }
    
    @isTest
    private static void testEntitlementTrigger() {
        
        Entitlement e = [Select Name,Id from Entitlement where Name='Universal Entitlement' LIMIT 1];
        Entitlement e2 = [Select Name,Id from Entitlement where Name='Bogus Entitlement' LIMIT 1];
        Account a = [Select Name,Id from Account where Name='Void company' LIMIT 1];
    	
        System.assert(e != NULL);
        System.assert(a != NULL);
    
        Test.startTest();
        
        Case c = new Case();
        c.Subject = 'Something is wrong';
        c.Description = 'Basic description here';
        c.Status = 'New';
        c.Priority ='High';
        c.AccountId = a.Id;
        insert c;
        
        Case c2 = new Case();
        c2.Subject = 'Something is wrong';
        c2.Description = 'Basic description here';
        c2.Status = 'New';
        c2.Priority ='High';
        c2.AccountId = a.Id;
        c2.EntitlementId = e2.Id;
        insert c2;
        
        Test.stopTest();
        
        Case caseAfter = [SELECT Id, EntitleMentId FROM Case WHERe Id = : c.Id];
        Case case2After = [SELECT Id, EntitleMentId FROM Case WHERe Id = : c2.Id];
        
        System.assertEquals(e.Id, caseAfter.EntitlementId); // this case should have a standard Entitlement
        System.assertEquals(e2.Id, case2After.EntitlementId); // this case already has an explicit entitlement assigned so it shouldn't have changed
    }

}