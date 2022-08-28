@isTest (SeeAllData=false)
private class CarPartServiceTest {

    @isTest 
    static void loadToContainerTest(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(FirstName='Test', LastName='Contact');
        insert con;
        Car__c car = new Car__c(Name = 'Test Car', Driver__c = con.id, Is_Paid__c = false);
        insert car;
        Container__c container = new Container__c(Account__c = acc.id);
        insert container;
        
        Car_Part__c carPart = new Car_Part__c(Car__c = car.id, Weight__c = 10000, Container__c = container.id, Is_Export__c = true);
        insert carPart;
        System.assertEquals(10000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);
        
        Car_Part__c carPart2 = new Car_Part__c(Car__c = car.id, Weight__c = 5000, Container__c = container.id, Is_Export__c = true);
        insert carPart2;
        System.assertEquals(15000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);
        Car_Part__c carPart3 = new Car_Part__c(Car__c = car.id, Weight__c = 10000);
        insert carPart3;
        carPart3.Container__c = container.id;
        carPart3.Is_Export__c = true;
        update carPart3;
        System.assertEquals(25000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);        
        Car_Part__c carPart4 = new Car_Part__c(Car__c = car.id, Weight__c = 15000, Container__c = container.id, Is_Export__c = true);
        insert carPart4;
        carPart4.Weight__c = 19000;
        update carPart4;
        System.assertEquals(44000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);

        Car_Part__c carPart5 = new Car_Part__c(Car__c = car.id, Weight__c = 1, Container__c = container.id, Is_Export__c = true);
        Test.startTest();
        Database.SaveResult result = Database.insert(carPart5, false);
        Test.stopTest();

        System.assertEquals('Container is full', result.getErrors()[0].getMessage());
    }

	@TestSetup
    static void ValC(){
        Contact acct = new Contact(Salutation = 'Mr', FirstName='Liz', LastName = 'Yan');
        insert acct;
        Car__c nameC = new Car__c(name = 'Kerim', driver__c = acct.Id);
        insert nameC;
        Account accN = new Account(Name = 'Kira');
        insert accN;
        Container__c ContN = new Container__c(Account__c = accN.Id);
        insert ContN;

        Car_Part__c nameCarPart = new Car_Part__c(Car__c = nameC.Id, Is_Export__c = true, Container__c = ContN.Id);
        
        List<Car_Part__c> CarPartList = new List<Car_Part__c>();
        CarPartList.add(nameCarPart);
        insert CarPartList;
    }
    
    @isTest
    static void ValB(){
        List<Car_Part__c> CarPartList2 = [SELECT Id, Name, Car__c, Is_Export__c, Container__c FROM Car_Part__c];
        //when
		Test.startTest();
		CarPartService.ValidateContainerField(CarPartList2);
        Test.stopTest();
		system.assertEquals(1, CarPartList2.size());
    }
}