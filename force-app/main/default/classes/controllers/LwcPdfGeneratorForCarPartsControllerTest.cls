@isTest
public with sharing class LwcPdfGeneratorForCarPartsControllerTest {
    @TestSetup static void Setup(){
        Contact con = new Contact(
            LastName = 'test'
        );
        insert con;
        Car__c car = new Car__c(
            Name = 'Mercedes',
            Driver__c = con.Id
        );
        insert car;
        Car_Part__c cp = new Car_Part__c(
            Price__c = 100,
            Car__c = car.Id
        );
        insert cp;
    }
    @isTest
    public static void GetCarParsTest() {
        Car__c car = [SELECT Id FROM Car__c WHERE Name = 'Mercedes'];
        Car_Part__c carPart = [SELECT Id FROM Car_Part__c];
        List<Car_Part__c> existingCarParts = LwcPdfGeneratorForCarPartsController.getCarParts(car.Id);
        System.assertEquals(carPart.Id, existingCarParts[0].Id);
    }
}