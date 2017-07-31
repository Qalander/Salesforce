@isTest
public class BudgetShareHandlerTest{

    public static TestMethod void BudgetShareInsert(){
    
        Contract__c con = TestHelper.GetContract(null, 5);
        User u = [Select Id, Email from User where Email != null AND IsActive = true LIMIT 1];
        
        List<BudgetShare__c> shareList = new List<BudgetShare__c>();
        for (Position__c pos : con.Positions__r){
            
                shareList.Add(new BudgetShare__c(Position__c = pos.Id, seller_email__c = u.Email, seller_share_percent__c = 100));
             
        }
        
        insert shareList;
    }
}