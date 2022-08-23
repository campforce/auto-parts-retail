@isTest
public class CheckContainerCapacityTest {
    @isTest static void test(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(FirstName='Test', LastName='Contact');
        insert con;
        Car__c car = new Car__c(Name = 'Test Car', Driver__c = con.id, Is_Paid__c = false);
        insert car;
        Container__c container = new Container__c(Account__c = acc.id);
        insert container;
        
        //Add new car part to empty container
        Car_Part__c carPart = new Car_Part__c(Car__c = car.id, Weight__c = 10000, Container__c = container.id);
        insert carPart;
        System.assertEquals(10000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);

        //Add new car part to container with car part
        Car_Part__c carPart2 = new Car_Part__c(Car__c = car.id, Weight__c = 5000, Container__c = container.id);
        insert carPart2;
        System.assertEquals(15000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);

        //Add new car part without container then update to add to container
        Car_Part__c carPart3 = new Car_Part__c(Car__c = car.id, Weight__c = 10000);
        insert carPart3;
        carPart3.Container__c = container.id;
        update carPart3;
        System.assertEquals(25000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);
        
        //Add new car part to container then update weight field
        Car_Part__c carPart4 = new Car_Part__c(Car__c = car.id, Weight__c = 15000, Container__c = container.id);
        insert carPart4;
        //Container's capacity is 40k now, update carPart3's weight to 19k
        //So it shoud substract first 15k from 40k which is 25k then add 19k which is 44k
        carPart4.Weight__c = 19000;
        update carPart4;
        System.assertEquals(44000, [Select Capacity__c From Container__c Where id =: container.id].Capacity__c);

        //Add new car part with 1 lbs weight
        //Container's current capacity is 44k so 44k + 1 > limits
        //This insertion should be prevented
        Car_Part__c carPart5 = new Car_Part__c(Car__c = car.id, Weight__c = 1, Container__c = container.id);
        Test.startTest();
            Database.SaveResult result = Database.insert(carPart5, false);
        Test.stopTest();
        System.assertEquals('Container is full', result.getErrors()[0].getMessage());
    }
}
