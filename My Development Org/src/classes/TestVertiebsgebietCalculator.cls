@isTest
public class TestVertiebsgebietCalculator {
	
    @isTest
    public static void testVertiebsgebietValidZipCode()
    {  
        List<Vertriebsgebiet__c> testData = new List<Vertriebsgebiet__c>();
        
        Vertriebsgebiet__c stuttgart = new Vertriebsgebiet__c(Name='Stuttgart', PLZ__c='70123');
        Vertriebsgebiet__c koeln = new Vertriebsgebiet__c(Name='Köln', PLZ__c='56052');
        Vertriebsgebiet__c hamburg = new Vertriebsgebiet__c(Name='Hamburg', PLZ__c='19246');
        Vertriebsgebiet__c berlin = new Vertriebsgebiet__c(Name='Berlin', PLZ__c='16598');
        Vertriebsgebiet__c muenchen = new Vertriebsgebiet__c(Name='München', PLZ__c='83788');
        Vertriebsgebiet__c frankfurt = new Vertriebsgebiet__c(Name='Frankfurt', PLZ__c='69789');
        Vertriebsgebiet__c nuernberg = new Vertriebsgebiet__c(Name='Nürnberg', PLZ__c='92296');
        Vertriebsgebiet__c essen = new Vertriebsgebiet__c(Name='Essen', PLZ__c='41369');
        Vertriebsgebiet__c leipzig = new Vertriebsgebiet__c(Name='Leipzig', PLZ__c='04357');
        Vertriebsgebiet__c hannover = new Vertriebsgebiet__c(Name='Hannover', PLZ__c='30159');
        
        testData.add(stuttgart);
        testData.add(koeln);
        testData.add(hamburg);
        testData.add(berlin);
        testData.add(muenchen);
        testData.add(frankfurt);
        testData.add(nuernberg);
        testData.add(essen);
        testData.add(leipzig);
        testData.add(hannover);
        
        insert testData;
        
        System.assertEquals('Stuttgart', VertriebsgebietCalculator.calculateVertriebsgebiet('70123'));
        System.assertEquals('Köln', VertriebsgebietCalculator.calculateVertriebsgebiet('56052'));
        System.assertEquals('Hamburg', VertriebsgebietCalculator.calculateVertriebsgebiet('19246'));
        System.assertEquals('Berlin', VertriebsgebietCalculator.calculateVertriebsgebiet('16598'));
        System.assertEquals('München', VertriebsgebietCalculator.calculateVertriebsgebiet('83788'));
        System.assertEquals('Frankfurt', VertriebsgebietCalculator.calculateVertriebsgebiet('69789'));
        System.assertEquals('Nürnberg', VertriebsgebietCalculator.calculateVertriebsgebiet('92296'));
        System.assertEquals('Essen', VertriebsgebietCalculator.calculateVertriebsgebiet('41369'));
        System.assertEquals('Leipzig', VertriebsgebietCalculator.calculateVertriebsgebiet('04357'));
        System.assertEquals('Hannover', VertriebsgebietCalculator.calculateVertriebsgebiet('30159'));
    }
    
    @isTest
    public static void testVertiebsgebietNullZipCode()
    {
        String location = VertriebsgebietCalculator.calculateVertriebsgebiet(null);
        System.assertEquals('TeleSales/Omnea', location);
    }
}