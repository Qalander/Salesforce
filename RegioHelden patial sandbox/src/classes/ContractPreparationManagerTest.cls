@isTest
public class ContractPreparationManagerTest{

    /*public static Testmethod void TestContractPreparation(){
        ContractPreparationManager mng = new ContractPreparationManager();
        
        Account acc = TestHelper.getAccount(new Account());
        
        insert acc;
        
        Opportunity opp = TestHelper.getOpportunity(new Opportunity(AccountId = acc.Id, TaskCreated__c = false));
        
        insert opp;
        
        mng.PrepareContract(new List<Id>{ opp.Id });
        
        System.assertEquals(true, [Select Id, TaskCreated__c FROM Opportunity WHERE Id = :opp.Id].TaskCreated__c);
        System.assertEquals(1, [Select Id FROM ContractPreparation__c].Size());
    }*/
}