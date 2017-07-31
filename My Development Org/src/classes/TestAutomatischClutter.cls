@isTest
public class TestAutomatischClutter {
      @isTest
    public static void Test_Batch2()
    { 
        List<case> lstCase= new List<case>();
        for(Integer i=0 ;i <10;i++)
        {
            Case caseObj = new Case(
                 Status = 'Offen',
                 Subject = 'Email: Wir haben Ihre Anfrage erhalten - Thema iLume Test Email2Case'
            );
            lstCase.add(caseObj);
        }  
       	insert lstCase;
        
        List<Task> lstTask= new List<Task>();
        for(Integer j=0 ; j<10;j++)
        {
            Task TObj = new Task(
                 Status = 'Offen',
                 Subject = 'Email: Wir haben Ihre Anfrage erhalten - Thema iLume Test Email2Case');
            lstTask.add(TObj);
        }  
 
        
        if(lstTask.size() > 0) {
            insert lstTask;
        }
           
    	Test.startTest();
        RemoveTaskAutomatischClutter obj = new RemoveTaskAutomatischClutter();
        Database.executeBatch(obj,10);
        Test.stopTest();
        }
  }