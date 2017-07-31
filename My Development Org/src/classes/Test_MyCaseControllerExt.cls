@isTest
public class Test_MyCaseControllerExt {

    @isTest
    public static void MyCaseControllerExt() {
        
        Test.startTest();
        
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
        cs.Reason = '6';
        cs.Service_Fall__c = '1';
        
        insert cs;

       	MyCaseControllerExt cext = new MyCaseControllerExt(new ApexPages.StandardController(cs));
        cext.save();
        
        Test.stopTest();
    }
}