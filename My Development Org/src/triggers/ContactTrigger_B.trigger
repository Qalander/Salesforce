trigger ContactTrigger_B on Contact (before delete, before insert, before update) {
	
	/*
	in case ownerid changes - sets Previous_User__c to the old ownerid
	*/
	
	if(!Trigger.isDelete) {
	    for(Contact c : Trigger.New){
			
	        if(Trigger.isUpdate) {
		    	if(c.ownerId != Trigger.oldMap.get(c.id).ownerid) {
		    		if(String.Valueof(Trigger.oldMap.get(c.id).ownerid).substring(0,3) == '005') {
		            	c.Previous_User__c = Trigger.oldMap.get(c.id).ownerid;
		    		} else {
		    			c.Previous_User__c = null; //previous was a queue
		    		}
		    	}
			}
	    }
	}
}