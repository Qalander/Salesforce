@isTest
global class Test_CaseTest {
    
    @isTest
    public static void Test_CaseTest() {
        Case cs = new Case();
        cs.Status = 'Offen';
        cs.Origin = 'Outbound Mail';
        cs.Reason = '5';
        cs.Service_Fall__c = 'Kundenbriefing durchführen';
        System.debug('########### cs: ' + cs);
        insert cs;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ApexPages.currentPage().getParameters().put('id', +'/'+cs.Id);
        
        CaseTest ct = new CaseTest(sc);
        
        PageReference pageRef = Page.UseCase;
        pageRef.getParameters().put('id', String.valueOf(cs.id));
        Test.setCurrentPage(pageRef);
        
        ct.Speichern();
        ct.Cancel();
        
        Test.stopTest();
    }
    
    @isTest
    public static void Test_CaseTestOrginNull() {
        Case cs = new Case();
        cs.Status = 'Offen';
        System.debug('########### cs: ' + cs);
        insert cs;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ApexPages.currentPage().getParameters().put('id', +'/'+cs.Id);
        
        CaseTest ct = new CaseTest(sc);
        
        PageReference pageRef = Page.UseCase;
        pageRef.getParameters().put('id', String.valueOf(cs.id));
        Test.setCurrentPage(pageRef);
        
        ct.Speichern();

        Test.stopTest();
    }
    
     @isTest
    public static void Test_CaseTestHTTPRequest() {        
        Case cs = new Case();
        cs.Status = 'Offen';
        cs.Origin = 'Outbound Mail';
        cs.Reason = '5';
        cs.Service_Fall__c = 'Kundenbriefing durchführen';
        System.debug('########### cs: ' + cs);
        insert cs;

        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ApexPages.currentPage().getParameters().put('id', +'/'+cs.Id);
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        CaseTest ct = new CaseTest(sc);
        
        PageReference pageRef = Page.UseCase;
        pageRef.getParameters().put('id', String.valueOf(cs.id));
        Test.setCurrentPage(pageRef);

        ct.getInfoFromExternalService();
        
        Test.stopTest();
    }
}