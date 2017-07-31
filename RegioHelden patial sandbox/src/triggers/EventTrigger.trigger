trigger EventTrigger on Event (after delete, after insert, after update, before delete, before insert, before update)
{
    TriggerFactory.createHandler(Event.sObjectType);
}