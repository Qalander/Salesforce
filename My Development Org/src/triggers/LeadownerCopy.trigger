trigger LeadownerCopy on Lead (before Update) {
	
	/*
    // handle arbitrary number of opps
    for(Lead x : Trigger.New){

        // check that owner is a user (not a queue)
        if( ((String)x.OwnerId).substring(0,3) == '005' ){
            x.Owner_Copy__c = x.OwnerId;
        }
        else{
            // in case of Queue we clear out our copy field
            x.Owner_Copy__c = null;
        }
    }
	*/
}