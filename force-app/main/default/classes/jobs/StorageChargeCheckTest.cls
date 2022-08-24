@isTest
public class StorageChargeCheckTest 
{
    @testSetup
    static void setup() 
    {
        Contact c = new Contact(LastName = 'TestDriver');
        insert c;
        List<Car__c> cars = new List<Car__c>();

        // insert 5 cars with different purchased day.
        for (Integer i = 3; i < 8; i++) 
        {
            cars.add(new Car__c(Name = 'Car' + i, Driver__c = c.id, Purchase_Date__c = System.now().AddDays(i)));
        }

        insert cars;
    }

    @isTest static void test()
    {
        Database.executeBatch(new StorageChargeCheckBatch());

        List<Car__c> allCars = [Select id, Storage_Cost__c From Car__c];

        Set<Car__c> cars = new Set<Car__c>();

        for (Car__c car : allCars)
        {
            if (car.Storage_Cost__c == null)
            {
                cars.add(car);
            }
            else if (car.Storage_Cost__c == 5)
            {
                cars.add(car);
            }
            else if (car.Storage_Cost__c == 10)
            {
                cars.add(car);
            }
            else if (car.Storage_Cost__c == 15)
            {
                cars.add(car);
            }
            else if (car.Storage_Cost__c == 125)
            {
                cars.add(car);
            }
        }
        System.assertEquals(5, cars.size());
    }
}