@isTest
private class CallOutClassTest {
   
   @isTest
   public static void testAccountCallout() {
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        //CaseTest.getInfoFromExternalService();
        //CaseTest csTest = new CaseTest();
        //csTest.getInfoFromExternalService();
        //System.assertEquals(/*check for expected results here...*/);
    }

}