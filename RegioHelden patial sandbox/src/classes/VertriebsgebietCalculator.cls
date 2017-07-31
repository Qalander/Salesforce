/** 
 * @author Dominic Recktenwald 
 * @implementationDate 12.01.17
 * @testclass TestVertiebsgebietCalculator
 * 
 * 
 * Within this class, we will calculate the Vertiebsgebiet,
 * depending on the PLZ of the object. We can use this class 
 * for all objects with a PLZ field and a custom field
 * "Vertriebsgebiet__c"
 * 
 */
public class VertriebsgebietCalculator 
{
    /**
     * Inside this function we will calculate
     * the Vertriebsgebiet of an given PLZ
     * 
     * @param plz - The plz as an Object
     * 
     */                                                                
    public static String calculateVertriebsgebiet(Object plz)
    {   
        //Default Vertiebsgebiet
        String vertiebsGebiet = 'TeleSales/Omnea';
        
        if(plz != null)
        {
            //Cast the plz parameter to a String
            String plzAsString = (String) plz;
            
            /**
             * Check to which set the given plz belongs
             * 
             */ 
            if(plzItarator(VertriebsgebietConstants.vertriebsgebieteStuttgart, plzAsString))
                vertiebsGebiet = 'Stuttgart';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteKoeln, plzAsString))
                vertiebsGebiet = 'Köln';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteHamburg, plzAsString))
                vertiebsGebiet = 'Hamburg';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteBerlin, plzAsString))
                vertiebsGebiet = 'Berlin';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteMuenchen, plzAsString))
                vertiebsGebiet = 'München';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteFrankfurt, plzAsString))
                vertiebsGebiet = 'Frankfurt';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteEssen, plzAsString))
                vertiebsGebiet = 'Essen';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteNuernberg, plzAsString))
                vertiebsGebiet = 'Nürnberg';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteLeipzig, plzAsString))
                vertiebsGebiet = 'Leipzig';
            else if(plzItarator(VertriebsgebietConstants.vertriebsgebieteHannover, plzAsString))
                vertiebsGebiet = 'Hannover';
            
            System.debug('Setting Vertiebsgebiet to: ' + vertiebsGebiet + ' with PLZ: ' + plzAsString);
        }
        
         return vertiebsGebiet; 
        
    }
    
    /**
     * Iterate over a given set of Vertiebsgebiete.
     * If the given PLZ matches with a list entry,
     * returns true, otherwise false
     * 
     * @param setToCheck - A set of strings
     * @param plz - The plz to check
     * 
     */ 
    private static boolean plzItarator(Set<Vertriebsgebiet__c> setToCheck, String plz)
    {
        /**
         * Iterate over each set entry
         * 
         */ 
        for(Vertriebsgebiet__c v : setToCheck)
        {
            /**
             * Check if the given plz equals with the current 
             * entry
             *  
             */
            if(v.PLZ__c == plz)
            {
                return true;
            }
        }
        
        return false;
    }
}