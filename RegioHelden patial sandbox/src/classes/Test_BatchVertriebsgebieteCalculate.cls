@isTest
public class Test_BatchVertriebsgebieteCalculate {
    static testMethod void myUnitTest() {   
        
        //Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('DeveloperNameOfRecordType').getRecordTypeId();
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType='Account' LIMIT 1];
    
        Account acc = new Account();
        acc.RecordType = rt;
        acc.Name = 'Test Account';
        acc.Phone = '+492156452';
        acc.Website = 'www.test-account.com';
        acc.Industry = 'KFZ';
        acc.industry_detail__c = 'Autoglas';
        acc.Vertriebsgebiet__c = 'TeleSales/Omnea';
        
        insert acc;
        
        Test.StartTest();
        	BatchVertriebsgebieteCalculate btc = new BatchVertriebsgebieteCalculate();
            Database.executeBatch(btc, 1);
        Test.stopTest();
    }    
    
}