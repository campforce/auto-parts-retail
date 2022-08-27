@isTest
public with sharing class LwcCarSoldPartChartControllerTest {
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
    static void getStatisticsTest() {
        Car__c car = [SELECT Id FROM Car__c];

        AggregateResult expCarPartSize = [SELECT COUNT(Id) FROM Car_Part__c WHERE Car__c =: car.Id];
        Integer actCarPartSize = LwcCarSoldPartChartController.getStatistics(car.Id).size();
        System.debug(expCarPartSize);
        System.debug(actCarPartSize);

    }
}
