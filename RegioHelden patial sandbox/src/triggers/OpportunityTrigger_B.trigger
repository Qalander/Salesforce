trigger OpportunityTrigger_B on Opportunity (before insert, before update) {
    
    /*
    in case ownerid changes - sets Previous_User__c to the old ownerid
    */
    
    for(Opportunity o : Trigger.New){
        
        if(Trigger.isUpdate) {
            if(o.ownerId != Trigger.oldMap.get(o.id).ownerid) {
                if(String.Valueof(Trigger.oldMap.get(o.id).ownerid).substring(0,3) == '005') {
                    o.Previous_User__c = Trigger.oldMap.get(o.id).ownerid;
                } else {
                    o.Previous_User__c = null; //previous was a queue
                }
            }
        }
    }
    
}