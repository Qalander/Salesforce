@isTest
public class CreateOpportunityControllerTest{

    public static TestMethod void TestController(){
        Account acc = new Account();
        acc.Phone = 'ka';
        acc.Name = 'Test-Account';
        User u = [Select Id from User WHERE isActive = true LIMIT 1];
        acc.OwnerId = u.Id;
        
        insert acc;
        upsert TestHelper.GetOpportunity(new Opportunity(AccountId = acc.Id));
        
        CreateOpportunityController c = new CreateOpportunityController();
        
        System.debug(acc.Id);
        Test.setCurrentPageReference(new PageReference('Page.CreateOpportunity'));

        ApexPages.currentPage().getParameters().put('accountId', [Select ID from Account LIMIT 1].Id);
        ApexPages.currentPage().getParameters().put('stage', 'Geschlossen und gewonnen');
        
        c.Wrap.Name = 'WinBack geeignet';
        c.Wrap.Budget = 50;
        c.Wrap.OwnerId = (Id)c.LocationLeader[0].getValue();
        integer names = c.getNames().size();
        
        Test.startTest();
        CreateOpportunityController.CreateOpportunity(acc.Id, 'Test 123', acc.OwnerID, 'Comment', 50, 'Geschlossen und gewonnen');
        Test.stopTest();
    }
}