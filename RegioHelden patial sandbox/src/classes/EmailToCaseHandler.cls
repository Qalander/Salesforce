/**
 * @author Dominic Recktenwald 
 * @implementationDate 16.01.17
 * 
 * Within this class, we will parse the  
 * case subject and description, by an email,
 * created with the origin 'Inbound - Mail'.
 * Depending on the content of this fields, we will
 * set the field 'Reason' of the new case
 * 
 */
public class EmailToCaseHandler 
{
    //Member variables
    private Case newCase;
    private List<Schema.PicklistEntry> reasonPickListEntries;
    private List<Schema.PicklistEntry> serviceFallPickListEntries;
       
    private EmailTaggingLists taggingList;
    /**
      * The constructor
      *
      */
    public EmailToCaseHandler(Case newCase)
    {
        this.newCase = newCase;
        taggingList = new EmailTaggingLists();
    }
    
    /**
      * Return the new case reason by the new case
      * subject
      */
    public List<String> getCaseReasonBySubject()
    {
        //return checkString(newCase.Subject);
        system.debug('****newCase.Subject = '+ newCase.Subject);
        List<String> reasonAndFall = checkForKeyWord(newCase.Subject);
        
        return reasonAndFall;
    }
    
    /**
      * Return the new case reason by the new case
      * description
      */
    public List<String> getCaseReasonByDescription()
    {
        List<String> reasonAndFall = checkForKeyWord(newCase.Description);
        
        return reasonAndFall;
    }
    
    /**
      * Inside this helper function, we check if we have to check
      * the Beschwerde field. Here we also iterate over a list of 
      * key words
      *
      * @param toCheck - The string to check
      */
    public boolean checkForBeschwerde(String toCheck)
    {
        //Get the beschwerde key list
        List<String> beschwerdeKeyList = taggingList.getBeschwerdeList();
        
        //Check if the string to check contains a value from the list
        if(stringContainsValueOfList(toCheck, beschwerdeKeyList))
            return true;
            
        //No value found return false;
        return false;
    }
    
    
    /**
      * Inside this function, we check for all releavnt keywords.
      * As a paarmeter, we use the string to check
      *
      * @param stringToCheck - The string which we check for keywords
      */
    private List<String> checkForKeyWord(String stringToCheck)
    {
        //Get the keyword map
        Map<String, Map<String, List<String>>> keyWordMap = taggingList.getKeyWordMap();
        
        //Indicator if we found a keyword
        Boolean keywordFound = false;
        //Case reason we found
        String caseReason = '';
        //Service fall to the found case reason/keyword combination
        String serviceFall = '';
        
        /**
          * At first, let us iterate over all the top level
          * keys. This key indicates also the Case Reason field,
          * e.g. 'Rechnung'
          *
          */
        for(String currentTopKey : keyWordMap.keySet())
        {
            //Get the String <-> List<String> Map of the current key
            Map<String, List<String>> currentKeyMap = keyWordMap.get(currentTopKey);
            
            /**
              * At next, we iterate over each key of the
              * map of the top level key. This key also indicates the servicefall
              * field, e.g. 'Debitor anpassen'
              *
              */
            for(String subStringKey : currentKeyMap.keySet())
            {
                //Get the list of keywords which match to the current toplevel key / subkey combination
                List<String> subStringList = currentKeyMap.get(subStringKey);
                
                /**
                  * At next we check if the string to search
                  * contains an entry of the subStringList, if so
                  * we found a match
                  *
                  */
                if(stringContainsValueOfList(stringToCheck, subStringList))
                {
                    //Set the values
                    serviceFall = subStringKey;
                    caseReason = currentTopKey;
                    keyWordFound = true;
                }
            }
            
            if(keyWordFound)
                break;
        }

        //The list  to return
        List<String> toReturn = null; 
        
        /**
          * We only set the list, if there is
          * something to set
          *
          */
        if(caseReason != '' && serviceFall != '')
        {
            toReturn = new List<String>();
        
            toReturn.add(caseReason);
            toReturn.add(serviceFall);
            
            return toReturn;
        }
        
        return toReturn;
    }
    
    /**
      * We use this custom helper function, to check
      * if a string contains at least one string from a
      * given list of strings
      *
      * @param toCheck - The String to check
      * @param stringList - List of string, whcih entries have to be in toCheck
      */
    private boolean stringContainsValueOfList(String toCheck, List<String> stringList)
    {
        //At first we lower the cases of the toCheck parameter
        String toCheckLowerCase = toCheck.toLowerCase();
        /**
          * Iterate over each entry of
          * the given list
          *
          */
        for(String s : stringList)
        {
            /**
              * This is a special case. One matching keys work as a pair.
              * This pairs have to be somewhere in the given string to check.
              * A pair looks like 'string1,string2,....,stringn'. So we check if the current
              * String contains the ',' char. If so we go on
              *
              *
              */
            if(s.containsAny(','))
            {
                //Split the string to an array, separated by ','
                String[] stringArray = s.split(',');
                
                /**
                  * This indicator helps to check if all substring are contained
                  * in the string to check
                  *
                  */
                Integer i = 0;
                
                /**
                  * Lets itarate over each substring
                  *
                  */
                for(String substring : stringArray)
                { 
                    //If the string to check contains the loweted substring, increase the counter
                    if(toCheckLowerCase.contains(subString.toLowerCase()))
                        i++;
                }
                
                /**
                  * Only if the indicator is equal to the size of the array, we return true.
                  * This indicates, that each substring was found
                  *
                  */
                if(i == stringArray.size())
                    return true;
            }
            else if(toCheck.contains(s))
                return true;
        }
        
        return false;
    }
}