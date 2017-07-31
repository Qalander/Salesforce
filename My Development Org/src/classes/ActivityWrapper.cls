global class ActivityWrapper implements Comparable {

    public sObject act;
    
    // Constructor
    public ActivityWrapper(sObject ac) {
        act = ac;
    }
    
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        ActivityWrapper compareTosObj = (ActivityWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if ((Date)act.get('ActivityDate') > (Date)compareTosObj.act.get('ActivityDate')) {
            // Set return value to a positive value.
            returnValue = -1;
        } else if ((Date)act.get('ActivityDate') < (Date)compareTosObj.act.get('ActivityDate')) {
            // Set return value to a negative value.
            returnValue = 1;
        }
        
        return returnValue;       
    }
}