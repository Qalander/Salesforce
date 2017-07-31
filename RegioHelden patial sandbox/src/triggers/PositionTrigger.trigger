trigger PositionTrigger on Position__c (after delete, after insert, after update, before delete, before insert, before update)
{
    TriggerFactory.createHandler(Position__c.sObjectType);
}