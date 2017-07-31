@isTest
public class TestLeadstatusCalculation {

	@isTest
	public static void testLeadStatusCalculation()
	{
		Test.startTest();
		Lead l = new Lead();
		l.LastName = 'Test';
		l.Company = 'Test Company';
		l.Website = 'www.testedas.de';
		l.Phone = 'ka';
		l.industry= 'KFZ';
		l.industry_detail__c = 'Abschleppdients';
		l.Status = 'Offen';
		
		insert l;
		
		Task t = new Task();
		t.Subject = 'Call';
		t.Result__c = 'Entscheider erreicht';
		t.ActivityDate = System.today();
		t.WhoId = l.Id;
		
		insert t;
		
		Lead insertedLead = [SELECT Id, Status FROM Lead];
		
		System.assertEquals('Offen', insertedLead.Status);
		
		Test.stopTest();
	}
}