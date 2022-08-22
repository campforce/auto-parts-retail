/**
 * Created by omurzakov on 20.08.2022.
 */
@IsTest(SeeAllData=false)

private class CarServiceTest {

    @IsTest
    static void CommissionCalculatorTest() {
        //given 
        Contact cont=new Contact(LastName='John');
        insert cont;

        Car__c priceLess1000= new Car__c (Name='Mercedes', Driver__c=cont.Id, Car_Cost__c=999);
        Car__c priceLess2000= new Car__c (Name='Toyota', Driver__c=cont.Id, Car_Cost__c=1999);
        Car__c priceLess5000= new Car__c (Name='Honda', Driver__c=cont.Id, Car_Cost__c=4999);
        Car__c priceLess10000= new Car__c (Name='BMW', Driver__c=cont.Id, Car_Cost__c=9999);
        Car__c priceMore10000= new Car__c (Name='Hyundai', Driver__c=cont.Id, Car_Cost__c=10001);

        //when
        Test.startTest();
        insert priceLess1000;
        insert priceLess2000;
        insert priceLess5000;
        insert priceLess10000;
        insert priceMore10000;
        Test.stopTest();

        //then
        Car__c testPriceLess1000= [SELECT Id, Name, Driver__c, Comission__c FROM Car__c WHERE Id=:priceLess1000.Id];
        Car__c testPriceLess2000= [SELECT Id, Name, Driver__c, Comission__c FROM Car__c WHERE Id=:priceLess2000.Id];
        Car__c testPriceLess5000= [SELECT Id, Name, Driver__c, Comission__c FROM Car__c WHERE Id=: priceLess5000.Id];
        Car__c testPriceLess10000= [SELECT Id, Name, Driver__c, Comission__c FROM Car__c WHERE Id=:priceLess10000.Id];
        Car__c testPriceMore10000= [SELECT Id, Name, Driver__c, Comission__c FROM Car__c WHERE Id=:priceMore10000.Id];

        
        System.assertEquals(testPriceLess1000.Comission__c, 170);
        System.assertEquals(testPriceLess2000.Comission__c, 250);
        System.assertEquals(testPriceLess5000.Comission__c, 300);
        System.assertEquals(testPriceLess10000.Comission__c, 350);
        System.assertEquals(testPriceMore10000.Comission__c, 400);    

    }
}