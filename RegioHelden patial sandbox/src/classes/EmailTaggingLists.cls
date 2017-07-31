/**
  * @author Dominic Recktenwald
  * @date 14.02.2017
  *
  * This class contains all keywords to check for if an email-to-case
  * is created. 
  * The class is structured as followed:
  * At the top, we hav a Map of type String <-> Map<String, List<String>>
  * The key of the map always represents the possible 'Case Reason'. The value to each
  * key is another map. 
  * This map use a string as a key, which represents the 'Servicefall'. The value of this map
  * are the keywords to check for
  *
  *
  */
public class EmailTaggingLists 
{
	//This is our master map, key is the Case Reason, value another map
    private Map<String, Map<String, List<String>>> keyWordMap;
    
    private List<String> beschwerdeList;
    
    //----------------------------Rechnung Key Words----------------------------------------//
    private static Map<String, List<String>> rechnungMap = new Map<String, List<String>>();
    
    //TODO!!!!!
    private static List<String> rechnungAllgemeinKeyWords = new List<String>{'Zahlung', 'Abbuchung', 'Rechnung', 'Rechnnungsnummer', 'Buchhaltung', 'Mahnung',
        														'Gutschrift', 'Korrekturrechnung'};
                                                                   
    private static List<String> rechnungNichtErhKeyWords = new List<String>{'Rechnung,zuschicken'};       
    private static List<String> rechnungKorrekturKeyWords = new List<String>{'Rechnung,falsch', 'Rechnung,korrigieren'}; 
    private static List<String> rechnungDatenAnpassKeyWords = new List<String>{'Rechnung,Anschrift'};    
    private static List<String> rechnungDatenDebitorKeyWords = new List<String>{'Rechnungsempfänger', 'Rechnung,geändert'};
    
    //----------------------------Feedback Key Words----------------------------------------//
    private static Map<String, List<String>> feedbackMap = new Map<String, List<String>>();
    
    private static List<String> feedbackWebsiteKeyWords = new List<String>{'Ihre Webseite ist fertig', 'Anpassen,webseite', 'Abändern,webseite', 'starten,webseite',
    																		'freigeben,webseite', 'passt so,webseite', 'in Ordnung,webseite', 'zurückrufen,webseite',
    																		'Ändern,webseite'};
    																		
    private static List<String> feedbackBannerKeyWords = new List<String>{'Ihre Banner sind fertig', 'Anpassen,banner', 'Abändern,banner', 'starten,banner', 'freigeben,banner',
    																		'passt so,banner', 'in Ordnung,banner', 'zurückrufen,banner', 'Ändern,banner'};
    																		
    private static List<String> feedbackKampagneKeyWords = new List<String>{'Starttermin', 'Start der Kampagne', 'Kampagnenstart', 'starten'};
    
    //----------------------------AdWords Key Words----------------------------------------//
    private static Map<String, List<String>> adWordsMap = new Map<String, List<String>>();
    
    private static List<String> adwordsOptimierungKeyWords = new List<String>{'AdWords', 'Anzeige', 'eingeben', 'gesucht', 'finde,nicht', 'Suchbergriff', 'Suchbegriffe',
    																			'Keyword', 'Keywords', 'Schlagwort', 'Schlagworte', 'Klickkosten', 'Klickpreis', 'Klickpreise'};
      
    private static List<String> adwordsPausierungKeyWords = new List<String>{'pausieren', 'Pausierung', 'still legen'};
    private static List<String> adwordsReaktivierungKeyWords = new List<String>{'reaktivieren', 'Reaktivierung'};
    
    //----------------------------SEO Key Words----------------------------------------//
    private static Map<String, List<String>> seoMap = new Map<String, List<String>>();
    
    //TODO!!!!!
    private static List<String> seoAllgemeinKeyWords = new List<String>{'SEO', 'Pressetext'};
    
    
    //----------------------------Webseite Key Words----------------------------------------//
    private static Map<String, List<String>> webseiteMap = new Map<String, List<String>>();
    
    //TODO!!!!!
    private static List<String> webseiteAllgemeinKeyWords = new List<String>{'Webseite', 'Zielseite', 'Seite', 'Landing Page', 'Website', 'Homepage', 'Marketingwebseite',
    																			'Mini Webseite', 'Helden Webseite', 'Unterseite', 'Header', 'Impressum'};
      
    //----------------------------Anrufmessung Key Words----------------------------------------//
    private static Map<String, List<String>> anrufmessungMap = new Map<String, List<String>>();
    
    //TODO!!!!!
    private static List<String> anrufmessungAllgemeinKeyWords = new List<String>{'Messrufnummer', 'Messrufnummern', 'Anrufmessung', 'Zugangsdaten', 'Login'};
    private static List<String> anrufmessungWeiterleitungKeyWords = new List<String>{'Anruf,weiterleiten', 'Telefon,weiterleiten', 'Rufnummer,weiterleiten',
    																				 'Messrufnummer,weiterleiten', 'Weiterleitung,ändern'};
    private static List<String> anrufmessungJingleKeyWords = new List<String>{'Bandansage,ändern', 'Bandansage,rausnehmen', 'Bandansage,löschen', 'Bandansage,abstellen',
    																			 'Bandansage,abstellen'};
    
    
    //----------------------------Kündigung Key Words----------------------------------------//
    private static Map<String, List<String>> kuendigungMap = new Map<String, List<String>>();
    
    private static List<String> kuendigungEintragenKeyWords = new List<String>{'Kündigung', 'kündige', 'kündigen', 'Zusammenarbeit,beenden', 'Kampagne,beenden', 
    																			'vertrag,stornieren', 'vertrag,widerufen', 'sofort,kündigen', 'fristlos,kündigen'};
    
    //Constructor
    public EmailTaggingLists()
    {
        initMaps();
    }
    
    /**
      * Getter for our master map
      *
      */
    public Map<String, Map<String, List<String>>> getKeyWordMap()
    {
        return keyWordMap;
    }
    
    public List<String> getBeschwerdeList()
    {
    	return beschwerdeList;
    }
        
    /**
      * Helper function for init all the sub maps
      * and the master map. We call this function inside of the 
      * constructor
      *
      */
    private void initMaps()
    {
    	//Init all sub maps
    	initRechnungMap();
    	initFeedbackMap();
    	initAdWordsMap();
    	initSEOMap();
    	initWebseiteMap();
    	initAnrufmessungMap();
    	initKuendigenMap();
        
        //Init the master map
        keyWordMap = new Map<String, Map<String, List<String>>>();
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'Rechnung'), rechnungMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'Feedback während der Konzeption'), feedbackMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'AdWords Kampagne'), adWordsMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'SEO'), seoMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'Website'), webseiteMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'Anrufmessung'), anrufmessungMap);
        keyWordMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Reason', 'Kündigung'), kuendigungMap);
      
        //
        initBeschwerdeList();
    }
    
    private void initRechnungMap()
    {
    	rechnungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Allgemein'), rechnungAllgemeinKeyWords);
        rechnungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Rechnung zuschicken'), rechnungNichtErhKeyWords);
        rechnungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Korrekturrechnung erstellen'), rechnungKorrekturKeyWords);
        rechnungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Abschlussrechnung erstellen'), rechnungDatenAnpassKeyWords);
        rechnungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Debitordaten ändern'), rechnungDatenDebitorKeyWords);
    }
    
    private void initFeedbackMap()
    {
    	feedbackMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Freigabe Webseite'), feedbackWebsiteKeyWords);
    	feedbackMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Freigabe der Banner'), feedbackBannerKeyWords);
    	feedbackMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Feedback zu AdWords Kampagne'), feedbackKampagneKeyWords);
    }
    
    private void initAdWordsMap()
    {
    	adWordsMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Änderungen an Kampagne'), adwordsOptimierungKeyWords);
    	adWordsMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Pausierung'), adwordsPausierungKeyWords);
    	adWordsMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Reaktivierung'), adwordsReaktivierungKeyWords);
    }
    
    private void initSEOMap()
    {
    	seoMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Allgemein'), seoAllgemeinKeyWords);
    }
    
    private void initWebseiteMap()
    {
    	webseiteMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Allgemein'), webseiteAllgemeinKeyWords);
    }
    
    private void initAnrufmessungMap()
    {
    	anrufmessungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Allgemein'), anrufmessungAllgemeinKeyWords);
    	anrufmessungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Zielrufnummer ändern'), anrufmessungWeiterleitungKeyWords);
    	anrufmessungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Bandansage ausstellen'), anrufmessungJingleKeyWords);
    }
    
    private void initKuendigenMap()
    {
    	kuendigungMap.put(getValueFromPicklistwithTranslatedValue('Case', 'Service_Fall__c','Kündigung eintragen'), kuendigungEintragenKeyWords);
    }
    
    /**
      * Init the ebschwerde map
      *
      */
    private void initBeschwerdeList()
    {
        beschwerdeList = new List<String>{'enttäuscht', 'entäuschend', 'falsch', 'fehlerhaft', 'Fehler', 'inkompetent', 'lügen', 'lüge',
        						'Abzocker', 'Abzocke', 'abzocken', 'Betrug', 'Betrüger', 'betrügen', 'Anwalt', 'verspätet',
        						'zu spät', 'keine leistung', 'schlecht', 'kriminell', 'unseriös', 'versrpochen', 'nicht vereinbar'};					
    }
    public String getValueFromPicklistwithTranslatedValue(String ObjectApi_name, string Field_name, string Field_Value){
  		List<String> lstPickvals=new List<String>();
  		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
    	Sobject Object_name = targetType.newSObject();
  		Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
	    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
	    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
	    List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
	 	map<String, String> ValueTest = new map<String, String>();    
	 	for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
       		ValueTest.put(a.getlabel(), a.getValue());
   		}
	 	
	 	return ValueTest.get(Field_Value);
    }
}