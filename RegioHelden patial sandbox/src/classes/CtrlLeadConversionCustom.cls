public class CtrlLeadConversionCustom {
    public Lead L {get;set;}
    public Id LeadId {get;set;}
     
    public CtrlLeadConversionCustom (ApexPages.StandardController controller){
        this.L= (Lead)controller.getRecord();
        LeadId = L.Id;
        L = [Select Id, RecordType.DeveloperName, OwnerId, Previous_User__r.Id, Status from Lead where id =: LeadId];
    }
    
    public PageReference Check(){ 
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(L.Id);
        if(L.Previous_User__r.Id != null)
        	Leadconvert.setOwnerId(L.Previous_User__r.Id);
    	else
    		Leadconvert.setOwnerId(L.OwnerId);
        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true limit 1];
        Leadconvert.setConvertedStatus('Produkt gekauft');
        //Leadconvert.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to   create an opportunity from Lead Conversion 
        Database.LeadConvertResult Leadconverts = Database.convertLead(Leadconvert);
        PageReference P = new PageReference('/'+L.Id); 
        return P;
    }
}