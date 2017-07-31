public class VertriebsgebietConstants 
{
	public static Set<Vertriebsgebiet__c> vertriebsgebieteKoeln = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Köln']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteStuttgart = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Stuttgart']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteBerlin = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Berlin']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteHamburg = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Hamburg']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteMuenchen = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'München']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteNuernberg = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Nürnberg']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteEssen = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Essen']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteFrankfurt = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Frankfurt']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteLeipzig = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Leipzig']);
    public static Set<Vertriebsgebiet__c> vertriebsgebieteHannover = new Set<Vertriebsgebiet__c>([SELECT PLZ__c FROM Vertriebsgebiet__c WHERE Name = 'Hannover']);
}