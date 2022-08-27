@isTest(SeeAllData=false)
private class ContainerServicerTest {
    
    @TestSetup
    static void setup(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(FirstName='Test', LastName='Contact');
        insert con;
        Car__c car = new Car__c(Name = 'Test Car', Driver__c = con.id, Is_Paid__c = false);
        insert car;
        Container__c container = new Container__c(Account__c = acc.id);
        insert container;
        Car_Part__c carPart = new Car_Part__c(Car__c = car.id, Container__c = container.id, Is_Export__c = true);
        insert carPart;
    }

    @isTest static void testReleaseContainer(){
        Container__c container = [Select id, Status__c From Container__c][0];
        container.Status__c = 'Release';

        Test.startTest();
        Database.SaveResult result = Database.update(container, false);
        Test.stopTest();

        System.assertEquals('We can\'t release containers with unpaid car parts!!!', result.getErrors()[0].getMessage());
    }
} 