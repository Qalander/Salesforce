@isTest
private class Test_CtrlLeadConversionCustom {

	static testmethod void test1() {
		Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TeleSales').getRecordTypeId();
		Lead l = new Lead();
	    l.LastName = 'Test';
	    l.RecordTypeId = devRecordTypeId;
	    l.Company = 'Test Company';
	    l.Website = 'www.testedas.de';
	    l.Phone = 'ka';
	    l.industry= 'KFZ';
	    l.industry_detail__c = 'Abschleppdients';
	    l.Status = 'Präsentation – kein Interesse';
    
    	insert l;
    	ApexPages.StandardController sc = new ApexPages.StandardController(l);
     	CtrlLeadConversionCustom Contr = new CtrlLeadConversionCustom(sc);
     	Contr.Check();
		
	}    
}