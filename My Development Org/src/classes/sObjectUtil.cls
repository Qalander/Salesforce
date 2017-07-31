public class sObjectUtil {
    
    public Map<Id, string> GenerateHtmlTable(Schema.Fieldset fset, Map<Id, List<sObject>> idMap){
        Map<Id, string> result = new Map<Id, string>();
        
        for (Id key: idMap.keySet()){
            List<sObject> sObjList = idMap.get(key);
            
            string table = '<table border="1" width="100%"><thead><tr>';
            
            //Create Tablehead
            for(Schema.FieldSetMember f : fset.getFields()) {
                table += '<th>' + f.getLabel() + '</th>';
            }        
            table += '</tr></thead><tbody>';
            
            //Create Entries
            for (sObject sObj: sObjList){
                table += '<tr>';
                
                for(Schema.FieldSetMember f : fset.getFields())
                    table += '<td>' + ConvertToString(f.getType(), sObj.get(f.getFieldPath())) + '</td>';
                table += '</tr>';
            }
            
            table += '</tbody></table>';
            
            result.put(key, table);
        }
    	return result;
    }
    
    public Map<Id, List<sObject>> SelectsObjects(Schema.Fieldset fset, string groupById, List<Id> sObjIds, string orderBy){
    	Map<Id, List<sObject>> result = new Map<Id, List<sObject>>();
        string query = 'Select ';
        for(Schema.FieldSetMember f : fset.getFields()) {
                query += f.getFieldPath() + ', ';
            }
            
        query += groupById + ', Id FROM ' + fset.getSObjectType().getDescribe().getName() + ' WHERE Id in :sObjIds ' + orderBy;
        List<sObject> sObjList = Database.query(query);
        
        for (sObject sObj :sObjList){
            if (result.containsKey((Id)sObj.get(groupById)))
                result.get((Id)sObj.get(groupById)).add(sObj);
            else
                result.put((Id)sObj.get(groupById), new List<sObject>{ sObj });
        }
        
        return result;
    }

    private string ConvertToString(Schema.DisplayType type, object value){
        if (value == null)
            return '';
        if (type == Schema.DisplayType.DATE)
            return ((Date)value).format();
        if (type == Schema.DisplayType.DATETIME)
            return ((DateTime)value).format();
        if (type == Schema.DisplayType.DOUBLE)
            return ((Decimal)value).format();
        if (type == Schema.DisplayType.CURRENCY)
            return ((Decimal)value).format() + ' €';
        
    	return String.valueOf(value);        
    }
    
}