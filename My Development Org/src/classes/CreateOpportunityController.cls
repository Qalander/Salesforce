public class CreateOpportunityController {

    Id accountId = ApexPages.currentPage().getParameters().get('accountId');
    public PageReference Save() {
        /*if (wrap.Name == 'WinBack geeignet' && (wrap.OwnerId == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Bitte bei einer Winback-Opportunity einen Standortleiter auswählen.'));
            return null;
            }*/
            
        CreateOpportunity(accountId, wrap.Name, wrap.OwnerId, wrap.Info, wrap.budget, ApexPages.currentPage().getParameters().get('stage'));
        
        PageReference ref = new PageReference('/' + accountId);
        ref.setRedirect(true);
        return ref;
    }
    
    private OppWrapper pwrap { get;set; }

    public OppWrapper Wrap { get {
        if (pwrap == null) pwrap = new OppWrapper(); return pwrap; } set {pwrap = value; } }
    
    private List<SelectOption> pLocationLeader;
    public List<SelectOption> LocationLeader { get {
        if (pLocationLeader == null){
            List<User> users = [SELECT Id, Email, FirstName, LastName, UserRole.Name FROM User WHERE (UserRole.Name like 'Standortleiter%' OR AvailableForWinbackOpps__c = true) AND IsActive = true];
            pLocationLeader = new List<SelectOption>();
            for (User u: users)
                pLocationLeader.add(new SelectOption(u.Id, u.UserRole.Name + ' - ' + u.FirstName + ' ' + u.LastName));
        }
        return pLocationLeader;
    }}
    
    public List<SelectOption> getNames() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('WinBack geeignet','WinBack geeignet'));
        options.add(new SelectOption('Upselling Potenzial','Upselling Potenzial'));
        return options;
    }
    
    @future
    public static void CreateOpportunity(Id accountId, string name, Id ownerId, string comment, decimal budget, string stageName){
        System.debug('AccountId: ' + accountId);
        ownerId = [SELECT OwnerId from Account WHERE Id = :accountId LIMIT 1].OwnerId;
        Opportunity opp = new Opportunity(
            Name = name,
            OwnerId = ownerId,
            Info_f_r_Upselling_Potenzial__c = name != 'WinBack geeignet' ? comment : '' ,
            CustomerCareComment__c =  name == 'WinBack geeignet' ? comment : '',
            AccountId = accountId,
            Amount = budget,
            StageName = stageName,
            WinBack_geeignet__c = name == 'WinBack geeignet' ? true : false,
            Upselling_Potenzial__c = name == 'Upselling Potenzial' ? true : false,
            CloseDate = Date.Today() + 30
        );
        
        insert opp;
    }
    
    public class OppWrapper{
    
        public string Name { get;set; }
        public decimal Budget { get;set; }
        public Id OwnerId { get;set; }
        public string Info { get;set; }
    }
}