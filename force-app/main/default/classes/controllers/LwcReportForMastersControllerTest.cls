/**
 * @author Dastan
 * @date 2022-08-23
 *
 * @description Test Class for LwcReportForMastersController Class
 */
@isTest
public with sharing class LwcReportForMastersControllerTest {
    @TestSetup
    static void makeData(){
        Contact contact = new Contact(
            LastName = 'test',
            Position__c = 'Master'
        );
        insert contact;
        Car__c car = new Car__c(
            Name = 'Mercedes',
            Driver__c = contact.Id,
            Master__c = contact.Id,
            Is_Dismantled__c = true
        );  
        insert car;
        Car_Part__c carPart1 = new Car_Part__c(
            Car__c = car.Id,
            Price__c = 100
        );
        insert carPart1;
        Car_Part__c carPart2 = new Car_Part__c(
            Car__c = car.Id,    
            Price__c = 200
        );
        insert carPart2;
        Car_Part__c carPart3 = new Car_Part__c(
            Car__c = car.Id,
            Price__c = 300
        );
        insert carPart3;
    }
    @isTest
    public static void getCarQuantityTest() {
        Contact contact = [SELECT Id FROM Contact WHERE LastName = 'test'];
        Decimal carsNumber = [SELECT COUNT() FROM Car__c WHERE Name = 'Mercedes'];
        Decimal existingCarsCount = LwcReportForMastersController.getCarQuantity(contact.Id);

        System.assertEquals(carsNumber, existingCarsCount);
    }
    @isTest
    public static void getRelatedCarPartsTest() {
        Contact contact = [SELECT Id FROM Contact WHERE LastName = 'test'];
        List<Car_Part__c> carPartList = [SELECT Id FROM Car_Part__c];
        List<LwcReportForMastersController.DataTableWrapper> wrapperList = LwcReportForMastersController.getRelatedCarParts(contact.Id);

        System.assertEquals(wrapperList.size(), 3);
    }   
}