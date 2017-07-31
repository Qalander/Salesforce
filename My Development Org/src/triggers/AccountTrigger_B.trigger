trigger AccountTrigger_B on Account (before delete, before insert, before update) {
	
	/*
	copies OwnerId to Owner_Copy__c
	in case ownerid changes - sets Previous_User__c to the old ownerid
	*/
	
	if(!Trigger.isDelete) {
		for (Account a : Trigger.new) {
	    	
	    	a.Owner_Copy__c = a.OwnerId;
			
			if(Trigger.isUpdate) {
		    	if(a.ownerId != Trigger.oldMap.get(a.id).ownerid) {
		    		if(String.Valueof(Trigger.oldMap.get(a.id).ownerid).substring(0,3) == '005') {
		            	a.Previous_User__c = Trigger.oldMap.get(a.id).ownerid;
		    		} else {
		    			a.Previous_User__c = null; //previous was a queue
		    		}
		    	}
			}
			
	    }
	}

}