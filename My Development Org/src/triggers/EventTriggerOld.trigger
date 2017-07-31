/**
 * Event Trigger
 */
trigger EventTriggerOld on Event (after delete, after insert, after undelete, 
after update) {
try{
    
    LastActivityManager acm = new LastActivityManager();
    
    if (trigger.size <= 2000) {
        if (trigger.isDelete) {
            acm.updateLastActivity(trigger.oldMap.values(), true);
        } else {
            acm.updateLastActivity(trigger.newMap.values(), false);
        }
    }
    }
    catch(Exception exc)
    {}
}