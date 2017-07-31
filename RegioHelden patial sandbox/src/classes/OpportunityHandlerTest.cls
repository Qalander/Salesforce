@isTest
public class OpportunityHandlerTest{
    
    public static TestMethod void TestMethods(){
        Opportunity opp = TestHelper.GetOpportunity(new Opportunity());
        
        insert opp;
        
        update opp;
        
        delete opp;
    }
        
    public static TestMethod void TestContractPreparation(){
        Test.StartTest();
        Account acc = TestHelper.GetAccount(new Account());
        insert acc;
        Opportunity opp = TestHelper.GetOpportunity(new Opportunity(AccountId = acc.Id));
        opp.StageName = 'Geschlossen und gewonnen';
        
        insert opp;
        //System.assertEquals(true, [Select Id, TaskCreated__c FROM Opportunity WHERE ID = :opp.Id].TaskCreated__c);
        
        opp.TaskCreated__c = false;
        
        update opp;
        //System.assertEquals(true, [Select Id, TaskCreated__c FROM Opportunity WHERE ID = :opp.Id].TaskCreated__c);
        //
        Database.executeBatch(new AccountUpdateBatch());
        Test.StopTest();
    }
}