public class ContractPreparationManager{

    /*public void PrepareContract(List<Id> oppIds){
        
        List<Opportunity> opps = [Select 
                Id, 
                Account.Id, 
                Account.Name, 
                Account.Kundenbetreuer_AdWords__c, 
                Account.Kundenbetreuer_SEO__c, 
                Account.Kundenbetreuer_Zusatzprodukt__c, 
                Amount, Product__c, 
                CommissionPercent__c,
                Wirksamkeit_zum__c,
                InternalComment__c
            FROM Opportunity 
            WHERE ID in :oppIds AND TaskCreated__c = false];
        
        List<ContractPreparation__c> preparations = new List<ContractPreparation__c>();
        Id queueId = [select Id from Group where DeveloperName = 'ContractPreperation' and Type = 'Queue'].Id;
        
        for (Opportunity opp: opps){
            Id personInCharge;
            
            IF (opp.Product__c == 'Google Adwords' && opp.Account.Kundenbetreuer_Adwords__c != null)
                personInCharge = opp.Account.Kundenbetreuer_Adwords__c;
            ELSE IF (opp.Product__c == 'SEO' && opp.Account.Kundenbetreuer_SEO__c != null)
                personInCharge = opp.Account.Kundenbetreuer_SEO__c;
            ELSE IF (opp.Account.Kundenbetreuer_Zusatzprodukt__c != null)
                personInCharge = opp.Account.Kundenbetreuer_Zusatzprodukt__c;
            ELSE
                personInCharge = queueId;
                
            preparations.add(new ContractPreparation__c(
                Name = opp.Account.Name + ': ' + opp.Product__c,
                InternalComment__c = opp.InternalComment__c,
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id,
                Budget__c = opp.Amount,
                Product__c = opp.Product__c,
                AgencyCommission__c = opp.CommissionPercent__c,
                OwnerId = personInCharge,
                StartAt__c = opp.Wirksamkeit_zum__c                
            ));
            
            opp.TaskCreated__c = true;
        }
        
        insert preparations;
        update opps;
    }*/
}