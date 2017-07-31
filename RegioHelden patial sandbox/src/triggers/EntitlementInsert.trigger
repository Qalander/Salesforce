/**
 * Assigns a standard entitlement to a case if no value for entitlement is present
 * 
 * @author Damola@die-interaktiven.de
 * @version 1.0 2016-08-17 Initial release
 * @see ... if any related Jira issue etc. is there or documentation in a wiki or so...
 */

trigger EntitlementInsert on Case (Before Insert,Before Update) {
    /*
insert the universal case
*/
    
    
    List <Entitlement> entls = [Select Name,Id from Entitlement e where e.Name='Universal Entitlement'];
    
    for (Case c: Trigger.new){
        
        if (c.EntitlementId==null){
            
            if (entls.size() > 0){
            
                c.EntitlementId=entls[0].Id;
            }       
        }
    }
}