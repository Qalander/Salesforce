global class TaskWrapper implements Comparable {
    public Task Ta;
    
    // Constructor
    public TaskWrapper(Task T) {
        Ta = T;
    }
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        TaskWrapper compareToOTask = (TaskWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (Ta.ActivityDate > compareToOTask.Ta.ActivityDate) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (Ta.ActivityDate < compareToOTask.Ta.ActivityDate) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}