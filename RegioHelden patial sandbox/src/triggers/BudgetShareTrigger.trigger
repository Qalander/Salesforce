trigger BudgetShareTrigger on BudgetShare__c (after delete, after insert, after update, before delete, before insert, before update)
{
    TriggerFactory.createHandler(BudgetShare__c.sObjectType);
}