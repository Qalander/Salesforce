@isTest
public class Test_UseCaseEditCtrl2 {

    @isTest
    public static void UseCaseEditCtrlMethod2() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        Case cs = new Case();
        cs.OwnerId = u.Id;
        cs.Status = 'Offen';
        cs.Origin = 'Outbound Mail';
        cs.Reason = '5';
        cs.Service_Fall__c = 'Kundenbriefing durchführen';
        
        insert cs;
        
        UseCaseEditCtrl2 ct = new UseCaseEditCtrl2(new ApexPages.StandardController(cs));
        ct.Cancel();
        //ct.SendRequest();
    }
}