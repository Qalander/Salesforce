public class TestHelper{

    /*Erstellt einen neuen Account für Tests
    Parameter:
    acc: Ein vordefinierter Account. Es sind nur die Felder gesetzt, die für den Test relevant sind. */
    public static Account GetAccount(Account acc){
        if (acc == null)
            acc = new Account();
        if (acc.Name == null) acc.Name = 'Test-Account';
        if (acc.Phone == null) acc.Phone = 'ka';
        
        return acc;
    }
    
    /*Erstellt einen neuen Kontakt für Tests
    Parameter:
    con: Ein vordefinierter Kontakt. Es sind nur die Felder gesetzt, die für den Test relevant sind. */
    public static Contact GetContact(Contact con){
        //to be implemented...
        return null;    
    }
    
    /*Erstellt eine neue Opportunity für Tests
    Parameter:
    opp: Eine vordefinierte Opportunity. Es sind nur die Felder gesetzt, die für den Test relevant sind. */
    public static Opportunity GetOpportunity(Opportunity opp){        
        if (opp.Name == null) opp.Name = 'Test-Opportunity';
        if (opp.StageName == null) opp.StageName = 'Termin';
        if (opp.CloseDate == null) opp.CloseDate = Date.Today();
        
        return opp;
    }
    
    /*Erstellt einen neuen Vertrag für Tests. Optional mit Historie
    Parameter:
    con: Ein vordefinierter Vertrag. Es sind nur die Felder gesetzt, die für den Test relevant sind. */
    public static Contract__c GetContract(Contract__c con, integer budgetHistories){
        if (con == null)
            con = new Contract__c();
        
        if (con.Account__c == null){
            Account acc = GetAccount(null);
            insert acc;
            con.Account__c = acc.Id;
        }
        if (con.product_id__c == null)
            con.product_id__c = '12345';
        
        insert con;
        
        List<Position__c> positions = new List<Position__c>();
        
        for (integer i = 0; i <= budgetHistories; i++){
           positions.add( new Position__c(
               Contract__c = con.Id,
               Budget__c = Math.random() * 1000
           ));
        }
        if (positions.Size() > 0) insert positions;
        
        
        return [Select Id, Name, (Select Id, Budget__c from Positions__r) FROM Contract__c WHERE Id = :con.Id LIMIT 1];   
    }
}