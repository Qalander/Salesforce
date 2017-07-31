@istest
private class TestAccountOwnerCopy{

static Testmethod void testtrigger() {
Account acc = new Account(); 
acc.Name='Test Account';
acc.phone='+49';
acc.Website='www.test.de';
acc.Industry='Agentur';
acc.Fax = '+49';
//acc.Mobiltelefon__c = '+49';

Test.startTest();
insert acc;

}}