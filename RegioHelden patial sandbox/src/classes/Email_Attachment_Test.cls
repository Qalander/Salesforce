@isTest
public class Email_Attachment_Test {
 
    @isTest
    public static void Email_Attachment() {
        
        Test.startTest();

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduserAA@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='aaABC', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='aastandarduser@testorg.com');
        insert u;
        
        case Cs= new case ();
        Cs.Status = 'Offen';
        Cs.Reason = '1';
        Cs.Origin = 'Inbound - Call';
        Cs.HasAttachment__c = False;
        Cs.Service_Fall__c = '6';
        CS.OwnerId = u.Id;
        
        insert Cs;
        
        case Cs2= new case ();
        Cs2.Status = 'Offen';
        Cs2.Reason = '1';
        Cs2.Origin = 'Inbound - Call';
        Cs2.HasAttachment__c = False;
        Cs2.Service_Fall__c = '6';
        Cs2.parentId = Cs.Id;
        CS2.OwnerId = u.Id;
       
        insert Cs2;
        
        Attachment att = new Attachment();
        att.Name = '00023456';
        att.ParentId = Cs2.Id;
        
        
        EmailMessage Em = new EmailMessage (
        FromAddress = 'ilume.regiohelden@gmail.com',
        ParentId = Cs2.parentId);
        insert Em;

        Cs2.HasAttachment__c = True;
        
        Update Cs2;
        
        Test.stopTest();
    }
}