public class UserController {
	public User loggedInUser {get;set;}
    
    public UserController()
    {
        loggedInUser = [Select Id, Username, HC_Key__c FROM User WHERE Id=:userinfo.getuserId()];
    }
    
    
    public PageReference save() 
    {
        update loggedInUser;
        return null;
    }
}