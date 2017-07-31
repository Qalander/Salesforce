public with sharing class UseCaseEditCtrl2 {
    
    public Case C {get;set;}
    public String CaseOwner {get;set;}
    public String Contact {get;set;}
    public String Account {get;set;}
    public String Status {get;set;}
    public String Quelle {get;set;}
    public String Priority {get;set;}
    public String Grund {get;set;}
    public String ServiceFall {get;set;}
    public Boolean Beschwerde {get;set;}
    public String Description {get;set;}
    
    public UseCaseEditCtrl2(ApexPages.StandardController controller){
        C = (Case)controller.getRecord();
       
        
    	CaseOwner = c.OwnerId;
        Contact = '';
		Account = '';
        Status = c.Status;
    	Quelle = c.Origin;
        Priority = c.Priority;
        Grund = c.Reason;
        ServiceFall = c.Service_Fall__c;  
        Beschwerde = c.Beschwerde__c;
        Description = c.Description;
    }
    
    public PageReference Cancel(){ 
    	
        PageReference P = New PageReference(+'/'+C.Id);
        return P;
    }
    
   
}