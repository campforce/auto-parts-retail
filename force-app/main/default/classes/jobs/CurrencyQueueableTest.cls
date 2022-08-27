@isTest
public with sharing class CurrencyQueueableTest {
    @TestSetup
    static void makeData(){
        Datetime todayDate = DateTime.newInstance(2021, 1, 31, 7, 8, 16);
        Contact contact = new Contact(
            LastName = 'test',
            Position__c = 'Master'
        );
        insert contact;
        Car__c car = new Car__c(
            Name = 'Mercedes',
            Purchase_Date__c = todayDate,
            Driver__c = contact.Id,
            Master__c = contact.Id,
            Car_Cost__c = 20000,
            Currency__c = 'AED'
        );
        insert car;
        Car__c car1 = new Car__c(
            Name = 'Mercedes',
            Purchase_Date__c = todayDate,
            Driver__c = contact.Id,
            Master__c = contact.Id,
            Car_Cost__c = 20000,
            Currency__c = 'AED'
        );
        insert car1;
        
    }
    @isTest
    public static void CurrencyQueueableTest1 (){
        Map<Id, Car__c> idToOldCarsMap = new Map<Id, Car__c>();
        List<Car__c> carList = [SELECT Id, Status__c FROM Car__c];
        for(Car__c c : carList){
            idToOldCarsMap.put(c.Id, c);
            c.Status__c = 'Done';
        }
        update carList;

        Test.setMock(HttpCalloutMock.class, new CurrencyConverterIntegrationTest.CurrencyConverterIntegrationMock()); 

        // CurrencyQueueable updateJob = new CurrencyQueueable(carList, carsToUpdate);
        // System.engueueJob(updateJob);

        System.assertEquals(2, [SELECT COUNT() FROM Car__c WHERE Status__c = 'Done']);
    }
}
