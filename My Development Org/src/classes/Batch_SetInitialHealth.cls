global with sharing class Batch_SetInitialHealth implements Database.Batchable<Sobject>, Database.Stateful, Database.AllowsCallouts {
    global Batch_SetInitialHealth (){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String Query = 'SELECT Id, Name, AdwordsContract__c , SEOContract__c, LastClosedTask__c, Projektmanager__c, AdWords_Start_Date__c, '+
            'SEO_Start_Date__c,OwnerId, Health__c, Vertriebsgebiet__c, Customer_Status__c, LP_Start_Date__c '+
            'FROM Account WHERE (CustomerStateAdwords__c = \'Kunde\' or CustomerStateSeo__c = \'Kunde\') and (Customer_Status__c = \'Bestandskunde\' '+
            'or Customer_Status__c = \'Neukunde\' or Customer_Status__c = \'Neustarter\') and (StatusSeo__c = \'Aktiv\' or StatusAdwords__c = \'Aktiv\') '+
            'AND (Key_Account__c != \'Kooperationspartner\' and Key_Account__c != \'Whitelabel-Partner\' and Key_Account__c != \'Indirekter Kunde - kein Kontakt\')';
        system.debug('***Query  = ' + Query );
       return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        system.debug('***** exceute');
        set<Id> SetAccountIdScope = new set<Id>();
        list<Task> ListTaskToCreate = new list<task>();
        list<Case> ListCaseToCreate = new list<Case>();
        List<Account> listAccountToUpdate = new list<Account>();
        list<Account> ListAccountToCheckCase = new list<Account>();
        set<Id> SetAccountIdScope2 = new set<Id>();
        list<Task> ListTaskToCreate2 = new list<task>();
        list<Case> ListCaseToCreate2 = new list<Case>();
        List<Account> listAccountToUpdate2 = new list<Account>();
        list<Account> ListAccountToCheckCase2 = new list<Account>();
        set<Id> SetAccountIdScope3 = new set<Id>();
        list<Task> ListTaskToCreate3 = new list<task>();
        list<Case> ListCaseToCreate3 = new list<Case>();
        List<Account> listAccountToUpdate3 = new list<Account>();
        list<Account> ListAccountToCheckCase3 = new list<Account>();
        set<Id> SetAccountIdScope4 = new set<Id>();
        list<Task> ListTaskToCreate4 = new list<task>();
        list<Case> ListCaseToCreate4 = new list<Case>();
        List<Account> listAccountToUpdate4 = new list<Account>();
        list<Account> ListAccountToCheckCase4 = new list<Account>();
        set<Id> SetAccountIdScope5 = new set<Id>();
        list<Task> ListTaskToCreate5 = new list<task>();
        list<Case> ListCaseToCreate5 = new list<Case>();
        List<Account> listAccountToUpdate5 = new list<Account>();
        list<Account> ListAccountToCheckCase5 = new list<Account>();
        set<Id> SetAccountIdScope6 = new set<Id>();
        list<Task> ListTaskToCreate6 = new list<task>();
        list<Case> ListCaseToCreate6 = new list<Case>();
        List<Account> listAccountToUpdate6 = new list<Account>();
        list<Account> ListAccountToCheckCase6 = new list<Account>();
        
        try {
            for(Account a : scope){
                if(!a.Name.containsIgnoreCase('regiohelden') && !a.Name.containsIgnoreCase('Garant') && !a.Name.containsIgnoreCase('BAL Tours GmbH') && 
                   !a.Name.containsIgnoreCase('BAL-Tours GmbH') ||
                  a.Name == 'Garant Immobilien Holding GmbH' ){
                    boolean a1 = a.LP_Start_Date__c > date.today() - 29;
                    boolean a2 = a.LastClosedTask__c > date.today() - 15;
                    boolean a3 = a.LP_Start_Date__c <= date.today() - 29;
                    boolean a4 = a.LP_Start_Date__c >= date.today() - 169;
                    boolean a5 = a.LastClosedTask__c > date.today() - 15;
                    boolean a6 = a.LP_Start_Date__c < date.today() - 168;
                    boolean a7 = a.LastClosedTask__c > date.today() - 57;
                    system.debug('****A1 = ' + a1);
                    system.debug('****a2 = ' + a2);
                    
                    system.debug('****A3 = ' + A3);
                    system.debug('****a4 = ' + a4);
                    system.debug('****A5 = ' + A5);
                    
                    system.debug('****a6 = ' + a6);
                    system.debug('****a7 = ' + a7);
                                
                    boolean b1 = a.LP_Start_Date__c < date.today() - 29;
                    boolean b2 = a.LP_Start_Date__c > date.today() - 169;
                    boolean b3 = a.LastClosedTask__c < date.today() - 14;
                    boolean b4 = a.LastClosedTask__c > date.today()- 29;
                    boolean b5 = a.LP_Start_Date__c < date.today() - 168;
                    boolean b6 = a.LastClosedTask__c < date.today() - 28;
                    boolean b7 = a.LastClosedTask__c > date.today() -  57;
                    system.debug('****b1 = ' + b1);
                    system.debug('****b2 = ' + b2);
                    
                    system.debug('****b3 = ' + b3);
                    system.debug('****b4 = ' + b4);
                    system.debug('****b5 = ' + b5);
                    
                    system.debug('****b6 = ' + b6);
                    system.debug('****b7 = ' + b7);
                    
                    boolean c1 = a.LP_Start_Date__c < date.today() - 168;
                    boolean c2 = a.LastClosedTask__c < date.today() - 56;
                    boolean c3 = a.LastClosedTask__c > date.today() - 85;
                    system.debug('****c1 = ' + c1);
                    system.debug('****c2 = ' + c2);
                    system.debug('****c3 = ' + c3);
                    
                    boolean d1 = a.LP_Start_Date__c > date.today() - 29;
                    boolean d2 = a.LastClosedTask__c < date.today() - 15;
                    boolean d3 = a.LP_Start_Date__c < date.today() - 29;
                    boolean d4 = a.LP_Start_Date__c > date.today() - 169;
                    boolean d5 = a.LastClosedTask__c < date.today() - 28;
                    boolean d6 = a.LP_Start_Date__c < date.today() - 168;
                    boolean d7 = a.LastClosedTask__c < date.today() - 84;
                    system.debug('****d1 = ' + d1);
                    system.debug('****d2 = ' + d2);
                    
                    system.debug('****d3 = ' + d3);
                    system.debug('****d4 = ' + d4);
                    system.debug('****d5 = ' + d5);
                    
                    system.debug('****d6 = ' + d6);
                    system.debug('****d7 = ' + d7);
                    
                    if(a.LastClosedTask__c== null && (a.AdWordsContract__c != null || a.SEOContract__c != null)){
                        a.Health__c = 50;
                        listAccountToUpdate.add(a);
                    }else if(a.LastClosedTask__c== null && a.AdWordsContract__c == null && a.SEOContract__c == null){
                        system.debug('****a.Id = ' + a.Id + ' ****Do nothing!!');
                        // Do nothing
                    }else{       
                        if(((a.LP_Start_Date__c > date.today() - 29) && (a.LastClosedTask__c > date.today() - 15)) || 
                            (((a.LP_Start_Date__c <= date.today() - 29) && (a.LP_Start_Date__c >= date.today() - 169)) && a.LastClosedTask__c > date.today() - 15) ||
                            (a.LP_Start_Date__c < date.today() - 168) && (a.LastClosedTask__c > date.today() - 57)){
                            //A
                            a.Health__c = 100;
                            listAccountToUpdate.add(a);
                        }else if(((a.LP_Start_Date__c < date.today() - 29) && (a.LP_Start_Date__c > date.today() - 169)) &&
                            ((a.LastClosedTask__c < date.today() - 14) && (a.LastClosedTask__c > date.today()- 29)) ||
                            ((a.LP_Start_Date__c < date.today() - 168) && (a.LastClosedTask__c < date.today() - 28) && a.LastClosedTask__c > date.today() -  57)){
                            //B
                            system.debug('******** a.LP_Start_Date__c = ' + a.LP_Start_Date__c);
                            a.Health__c = 80;
                            listAccountToUpdate.add(a);
                        }else if ((a.LP_Start_Date__c < date.today() - 168) || (a.LastClosedTask__c < date.today() - 56) && 
                            (a.LastClosedTask__c > date.today() - 85)){
                                //C
                            a.Health__c = 60;
                            listAccountToUpdate.add(a);                                         
                        }else if(((a.LP_Start_Date__c > date.today() - 29) && (a.LastClosedTask__c < date.today() - 15)) || 
                            ((a.LP_Start_Date__c < date.today() - 29) && (a.LP_Start_Date__c > date.today() - 169) ||  (a.LastClosedTask__c < date.today() - 28)) ||
                            ((a.LP_Start_Date__c < date.today() - 168 && a.LastClosedTask__c < date.today() - 84))) {
                            //D             
                            a.Health__c = 50;
                            listAccountToUpdate.add(a);
                        }
                    }
                }
            }
            if(listAccountToUpdate.size()>0)
                update listAccountToUpdate;
        }catch(Exception e){
            System.debug('******Exception e '+e +' at line '+e.getLineNumber());
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :BC.getJobId()];
        system.debug('JobId :' + a.id);
        System.abortJob(a.Id);
   }
}