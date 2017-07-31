global class OwnerManager {

    webservice static string HandleSObjects(List<string> SObjectIds, String ObjectName){
    
        list<sobject> objectlist = new list<sobject>();
       

       if (SOBjectIds == NULL) 
        { 
            return 'Bitte wähle mindestens ein Objekt aus'; 
        } 
       else 
        { 
            for (string SObjectid:SObjectIds) 
                { 
                    sObject a = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
                    a.id = SObjectid; 
                    a.put('OwnerID', UserInfo.getUserId());
                    objectlist.add(a);
                    //a.Accountpool__c = ''; //im Workflow abbilden
                } 
        }

        if (objectlist.size() > 0 )
        {
            update objectlist; 
            
        }
       
        return 'Update erfolgreich';
    }
}