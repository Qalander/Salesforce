public class CaseTest{
    public Boolean Confirmed {get;set;}
    public boolean ShowMask {get;set;}
    public Case C {get;set;}
    public user currentuser{get;set;}
    
    
    public CaseTest(ApexPages.StandardController controller){
        C = (Case)controller.getRecord();
        ShowMask = false;
        Confirmed = false; 
        
     currentuser=new User();
     currentuser=[Select Id,Name FROM User WHERE Id=:userinfo.getuserId()];  
    }
    
    public PageReference Speichern(){ 
    	system.debug('***Speichern');

        if(c.Origin == null || c.Reason == null || c.Service_Fall__c == null)
            //if(Case.OwnerId == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
    		return null;
        }
        
        /*if(C.Reason == 'Upselling/Crossselling' && C.Service_Fall__c == 'Budgetänderung'){
            ShowMask = true;  
        }*/
        upsert C;
        //PageReference P = Page.UseCaseEdit;
        PageReference P = New PageReference(+'/'+C.Id);
        return P;
        
         
    }
     public PageReference Cancel(){ 
    	
        PageReference P = New PageReference(+'/'+C.Id);
        return P;
    }
    
    /*
    public reset(){
          case obj = (case) controller.getRecord();
          if(obj.Picklist__c == null) {
            obj.Picklist__c = (String) 
              Case.Account.Id.getDescribe().getDefaultValue();
          }
        }
*/
     
    public HTTPResponse getInfoFromExternalService(){
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://herocentral.de/api/v1/customers/budget-change/?token=7580043ab036a76bb2289bc59f38d7d6635d0272');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"name":"mighty moose"}');
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Parse the JSON response
                
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
       }
        return response;
    }
}