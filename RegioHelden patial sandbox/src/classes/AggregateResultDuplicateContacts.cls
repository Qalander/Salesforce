public class AggregateResultDuplicateContacts {

    public static void AggregateResultDuplicateContacts() {
        
        List<AggregateResult> con = [SELECT Name, count(Id) FROM Contact GROUP BY Name HAVING count(Id)>1];
            
        for(AggregateResult aggres : con)
            {
            System.debug('Finding duplicate names'+aggres);
            }
    }
}