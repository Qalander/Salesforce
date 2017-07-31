@isTest(SeeAllData=true)
private class TriggersTest {

    static testMethod void BestellungTrigger_Test() {
    
        Account acc = new Account(name = 'acc1', Phone = '+49123');
        insert acc;
        
        Contact con = new Contact(lastname = 'con1', accountid = acc.id, Phone = 'ka');
        insert con;
        
        Opportunity opp = new Opportunity(name = 'opp1', accountid = acc.id, CloseDate = Date.today(), StageName = 'Termin');
        insert opp;
        
        Lead lead = new Lead(lastname = 'con1', company = 'company', Phone = '+49123');
        insert lead;
        
    }
    
    static TestMethod void TriggerException_Test(){
        TriggerException exc = new TriggerException('Test für Exception');
        exc.TriggerMessage = 'Test';
        string test = exc.TriggerMessage;
    }    
}