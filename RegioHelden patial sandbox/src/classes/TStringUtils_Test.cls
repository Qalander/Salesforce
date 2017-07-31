@isTest
public class TStringUtils_Test {
	
    @isTest
    public static void validTest(){
        TStringUtils.GetDependentOptions('Case', 'Reason', 'Service_Fall__c');
    }
    
    @isTest
    public static void validObjectError(){
        TStringUtils.GetDependentOptions('Tree', 'Reason', 'Service_Fall__c');
    }
    
    @isTest
    public static void validControllingFieldError(){
        TStringUtils.GetDependentOptions('Case', 'Duck', 'Service_Fall__c');
    }
    
    @isTest
    public static void validDependentFieldError(){
        TStringUtils.GetDependentOptions('Case', 'Reason', 'Car');
    }
}