trigger CaseUpdateOnEmailMessage on EmailMessage (after  insert) 
{
    Set<Id> ParentId = new Set<Id>();
     Set<Id> ParentId2 = new Set<Id>();
     Set<Id> ParentId3 = new Set<Id>();
     Set<Id> ParentId4 = new Set<Id>();
     Set<Id> ParentId5 = new Set<Id>();
     Set<Id> ParentId6 = new Set<Id>();
     Set<Id> ParentId7 = new Set<Id>();
     Set<Id> ParentId8 = new Set<Id>();
     Set<Id> ParentId9 = new Set<Id>();
     Set<Id> ParentId10 = new Set<Id>();
     Set<Id> ParentId11 = new Set<Id>();
     Set<Id> ParentId12 = new Set<Id>();
     Set<Id> ParentId13 = new Set<Id>();
     Set<Id> ParentId14 = new Set<Id>();
     Set<Id> ParentId15 = new Set<Id>();
     Set<Id> ParentId16 = new Set<Id>();
     Set<Id> ParentId17 = new Set<Id>();
     Set<Id> ParentId18 = new Set<Id>();
     Set<Id> ParentId19 = new Set<Id>();
     Set<Id> ParentId20 = new Set<Id>();
    for(EmailMessage em: Trigger.new)
     {
         if(em.HasAttachment)
         {
           ParentId.add(em.ParentId);
         }
     }
     List<Case> lstCases = [select Id , HasAttachment__c from Case where Id IN :ParentId];
     For(Case c : lstCases)
     {
        c.HasAttachment__c = True;
     }

     update lstCases;
}