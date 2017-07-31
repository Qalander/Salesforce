trigger LeadTrigger_B on Lead (before delete, before insert, before update) {
	
	/*
	copies OwnerId to Owner_Copy__c
	in case ownerid changes - sets Previous_User__c to the old ownerid
	*/
	
	if(!Trigger.isDelete) {
	    for(Lead l : Trigger.New){
	    	try {
		    	// check that owner is a user (not a queue)
		        if( ((String)l.OwnerId).substring(0,3) == '005' ){
		            l.Owner_Copy__c = l.OwnerId;
		        }
		        else{
		            // in case of Queue we clear out our copy field
		            l.Owner_Copy__c = null;
		        }
	    	} catch (Exception e) {} //exception thrown on web2lead
	        
	        if(Trigger.isUpdate) {
	        	try {
			    	if(l.ownerId != Trigger.oldMap.get(l.id).ownerid) {
			    		if(((String)Trigger.oldMap.get(l.id).ownerid).substring(0,3) == '005') {
			            	l.Previous_User__c = Trigger.oldMap.get(l.id).ownerid;
			    		} else {
			    			l.Previous_User__c = null; //previous was a queue
			    		}
			    	}
	        	} catch (Exception e) {} //exception thrown on web2lead
			}
	    }
	}
}