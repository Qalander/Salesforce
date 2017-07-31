global class CaseWrapper implements Comparable {
    public Case Ca;
    
    // Constructor
    public CaseWrapper(Case C) {
        Ca = C;
    }
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        CaseWrapper compareToOCase = (CaseWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (Ca.ClosedDate > compareToOCase.Ca.ClosedDate) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (Ca.ClosedDate < compareToOCase.Ca.ClosedDate) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}