global class RollUpManager {
    
    webservice static void StartBatch(string query){
        RollUpBatch ruBatch = new RollUpBatch(query);
        Database.executeBatch(ruBatch);
    }
    
    public void RollUpTasks(Set<Id> sObjectIds){ 
        try{
            /*
                Abruf von Accounts, Opportunities, Kontakten, Leads
                Letzter Anruf, Letzte E-Mail, Letzter Besuch, Zukünftige Aktivität
                + jeweils Inhaber spezifisch
            */
            
            Map<string, Map<Id, sObject>> idMap = new Map<string, Map<Id, sObject>>();
            
            for (Id objId: sObjectIds){
                string prefix = ((string)objId).substring(0,3);
                
                if (idMap.containsKey(prefix))
                    idMap.get(prefix).put(objId, null);
                else                
                    idMap.put(prefix, new Map<Id, sObject>{objId => null});            
            }
            
            List<TaskRollUpSetting__c> settings = [
                SELECT Sobject__c, RollUpField__c, FilterCriteriaTasks__c, FilterCriteriaEvents__c, ByOwner__c, Prefix__c  
                FROM TaskRollUpSetting__c 
                WHERE IsActive__c = true AND Prefix__c IN :idMap.keySet()];
            
            Map<Id, sObject> updateMap = new Map<Id, sObject>();
            if (settings.size() <= 50){
                for (TaskRollUpSetting__c setting: settings){
                    string query = 'Select ID, OwnerId, ' + 
                        '(Select ID, OwnerId, ActivityDate FROM Tasks {1} ORDER BY ActivityDate DESC LIMIT 50), ' +
                        '(Select ID, OwnerId, ActivityDate FROM Events {2} ORDER BY ActivityDate DESC LIMIT 50)' +
                        'FROM {0} WHERE ID in :sObjectIds ALL ROWS';
                    
                    for (sObject obj: Database.Query(string.format(query, new List<string>{setting.Sobject__c, setting.FilterCriteriaTasks__c, setting.FilterCriteriaEvents__c}))){
                        Date result;
                        List<ActivityWrapper> objList = new List<ActivityWrapper>();
                        if (((List<sObject>)obj.getSObjects('Tasks')) != null && 
                            ((List<sObject>)obj.getSObjects('Tasks')).Size() > 0)
                            for (sObject sObj : (List<sObject>)obj.getSObjects('Tasks'))
                                objList.add(new ActivityWrapper(sObj));
                        
                        if (((List<sObject>)obj.getSObjects('Events')) != null && 
                            ((List<sObject>)obj.getSObjects('Events')).Size() > 0)
                            for (sObject sObj : (List<sObject>)obj.getSObjects('Events'))
                                objList.add(new ActivityWrapper(sObj));
                        
                        objList.Sort();
                        
                        if (objList.Size() > 0){
                                for (ActivityWrapper wrap: objList){
                                    if ((Id)Obj.get('OwnerId') == (Id)wrap.act.get('OwnerId') || !setting.ByOwner__c){
                                        result = (Date)wrap.act.get('ActivityDate');
                                        
                                        break;
                                    }
                                }
                            }
                        
                        if (updateMap.containsKey(obj.Id)){
                            updateMap.get(obj.Id).put(setting.rollUpField__c, result);
                            updateMap.get(obj.Id).put('BypassValidation__c', true);
                            }
                        else{
                            obj.put(setting.rollUpField__c, result);
                            obj.put('BypassValidation__c', true);
                            updateMap.put(obj.Id, obj);
                        }
                    }
                    
                }
            }        
            
            update updateMap.values();   
        }
        catch(Exception exc){
            throw exc;
        }
    }
}