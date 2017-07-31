@istest
private class TestLeadOwnerCopy{

	static Testmethod void testtrigger() {
		Lead x = new Lead();
		x.phone='+490123';
		x.Website='www.test.de';
		x.Industry='Agentur';
		x.LastName='Schmidt';
		x.Company='Interim-Group';
		x.Fax = '+49';
		//x.Mobiltelefon__c = '+49';
		
		Test.startTest();
		insert x;
		test.stopTest();
	}

	static Testmethod void testLeadConversion1() {
		Id IdRecordTypeTeleSales = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TeleSales').getRecordTypeId();
		Lead L = new Lead();
		L.RecordTypeId = IdRecordTypeTeleSales;
		L.phone='ka';
		L.Website='www.test.de';
		L.Industry='TestConversion';
		L.LastName='TestConversion';
		L.Company='TestConversion-Group';
		L.Fax = '+49';
		L.status = 'Schlechte Erreichbarkeit';
		L.LeadSource = 'Telesales';
		
		Test.startTest();
		insert L;
		test.stopTest();
	}
		static Testmethod void testLeadConversion2() {
		Lead L = new Lead();
		Id IdRecordTypeTeleSales = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TeleSales').getRecordTypeId();
		L.RecordTypeId = IdRecordTypeTeleSales;
		L.phone='ka';
		L.Website='www.test.de';
		L.Industry='TestConversion';
		L.LastName='TestConversion';
		L.Company='TestConversion-Group';
		L.Fax = '+49';
		L.status = 'Schlechte Erreichbarkeit';
		L.LeadSource = 'In Bearbeitung';
		
		Test.startTest();
		insert L;
		L.LeadSource = 'Telesales';
		update L;
		test.stopTest();
	}
}