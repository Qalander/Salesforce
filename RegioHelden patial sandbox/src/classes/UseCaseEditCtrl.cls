public with sharing class UseCaseEditCtrl {
    public boolean ShowMask {get;set;}
    public Case C {get;set;}
    public String Input1 {get;set;}
    public String Input2 {get;set;}
    public String Input3 {get;set;}
    public String Input4 {get;set;}
    public String Input5 {get;set;}
    public String Input6 {get;set;}
    public String Input7 {get;set;}
    public String Input8 {get;set;}
    public String Input9 {get;set;}
    
    public UseCaseEditCtrl(ApexPages.StandardController controller){
        C = (Case)controller.getRecord();
        ShowMask = false;
        system.debug('C.Reason = ' + C.Reason);
        system.debug('C.Service_Fall__c = ' + C.Service_Fall__c);
        if(C.Reason == 'Upselling/Crossselling' && C.Service_Fall__c == 'Budgetänderung'){
            ShowMask = true;  
        }
        system.debug('****ShowMask = ' + ShowMask);
        
    input1 = '123456';
    input2 = '2018-02-01';
    input3 = '2017-12-01';
    input4 = '2018-12-01';
    input5 = '455.20';
    input6 = '100.50';
    input7 = '50.75';
    input8 = '80.25';
    input9 = 'Test 123';
    
    }
    
    public PageReference Cancel(){ 
    	
        PageReference P = New PageReference(+'/'+C.Id);
        return P;
    }
    
    public void SendRequest(){
    	/*Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://herocentral.de/api/v1/customers/budget-change/?token=7580043ab036a76bb2289bc59f38d7d6635d0272');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		// Set the body as a JSON object
		request.setBody('{"product": "30558","signed_at": "2017-12-01","valid_from": "2017-12-01","contract_files_ids": "27517,27787","budget": 455.20,"commission": 1.3,"fee": 1.2,"setup_fee": 44.25,"accounting_info": "Custom text field for some info"}');
		HttpResponse response = http.send(request);
		// Parse the JSON response
		system.debug('****response.getStatusCode() #' + response.getStatusCode());
		if (response.getStatusCode() != 201) {
		    System.debug('The status code returned was not expected: ' +
		        response.getStatusCode() + ' ' + response.getStatus());
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Fehler beim Verarbeiten der Anfrage'));
		} else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Anfrage wurde erfolgreich verarbeitet und der Case geschlossen'));
		    System.debug('MAGRSHFJG' + response.getBody());
		    c.Status = 'Closed';
		    update c;
            
		}*/
        
        c.Accounting_Info__c = '7580043ab036a76bb2289bc59f38d7d6635d0272';
        update c;
    }
}