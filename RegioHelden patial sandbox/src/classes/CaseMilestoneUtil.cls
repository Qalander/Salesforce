public class CaseMilestoneUtil {
	    /**
      * Within this function, we will get all casemilestones 
      * with the given name inside all given caseids.
      * We will set the completion date of each found milestone to the
      * given date
      */
    public static void completeMilestoneByName(Id caseId, String milestoneName, DateTime complDate) { 
    	 
    	//Get all casemilestones by the given name
	    List<CaseMilestone> caseMileStoneToUpdate = [SELECT Id, completionDate FROM CaseMilestone cm WHERE caseId = :caseId AND cm.MilestoneType.Name=:milestoneName 
	            							AND completionDate = null];
	          
	    //Check if the list is empty						
	    if(!caseMileStoneToUpdate.isEmpty())
	    {
	    	//Iterate over each element inside the list
	        for(CaseMilestone cm : caseMileStoneToUpdate)
	        {
	        	//Set the completion date of the current element
	            cm.completionDate = complDate;
	        }
	        
	        //Update the list
	        update caseMileStoneToUpdate;
	    }
    }
    
    /**
      * Inside this function we collect all open milestones of
      * eache case given by the id list. If we found at least one element,
      * we will close it by setting the completion date
      *
      */
    public static void completeAllMilestones(Id caseId, DateTime complDate)
    {
    	//Get all open casemilestones of each case
    	List<CaseMilestone> caseMileStoneToUpdate = [SELECT Id, completionDate FROM CaseMilestone cm WHERE caseId =:caseId AND completionDate = null];
    
    	//Check if the list is empty
    	if(!caseMileStoneToUpdate.isEmpty())
	    {
	    	//List is not empty. Itaret over it
	        for(CaseMilestone cm : caseMileStoneToUpdate)
	        {
	        	//Set the completion date
	            cm.completionDate = complDate;
	        }
	        
	        //Update the list
	        update caseMileStoneToUpdate;
	    }
    }
}