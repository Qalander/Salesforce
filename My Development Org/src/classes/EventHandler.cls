/**
 * Class EventHandler
 *
 * Trigger Handler for the Event SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class EventHandler implements ITrigger
{   
    Set<Id> sObjectIds = new Set<Id>();
    
    // Constructor
    public EventHandler() {
    }
   
    public void bulkBefore() {
    }
    
    public void bulkAfter() {
    }
        
    public void beforeInsert(SObject so) {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
    }
    
    public void beforeDelete(SObject so) {
    }
    
    public void afterInsert(SObject so) {
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
    }
    
    public void afterDelete(SObject so) {
    }
    
    public void andFinally() {
    }
}