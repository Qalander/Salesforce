@isTest(seeAllData=true) 

public class TestRemoveEmailCaseClutter {
   @isTest
    public static void Test_Batch()
     
    { 
      List<case> lstCase= new List<case>();
        for(Integer i=0 ;i <200;i++)
        {
            Case caseObj = new Case(
                 Status = 'Offen',
                 Subject = ' Email :Wir haben Ihre Anfrage erhalten dfghhrssasfhrd'
            );
            lstCase.add(caseObj);
        }  
       	insert lstCase; 
        
      List<EmailMessage> ListEmailToDelete = New list<EmailMessage>();
        for(Integer j=0;j <100;j++)
        {
            EmailMessage emp = new EmailMessage(
                 
                 Subject = 'Email :Wir haben Ihre Anfrage erhalten dfghhrssasfhrd',
                 Incoming = false
            );
            ListEmailToDelete.add(emp);   
        }  
       	insert ListEmailToDelete;  
        
        if(ListEmailToDelete.size()>0)
           delete ListEmailToDelete; 
      
        Test.startTest();
            RemoveEmailCaseClutter obj = new RemoveEmailCaseClutter();
      
            Database.executeBatch (obj,100);
        Test.stopTest();
        }
    	
}