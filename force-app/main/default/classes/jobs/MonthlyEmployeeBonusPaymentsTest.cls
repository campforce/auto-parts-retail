
@isTest
public with sharing class MonthlyEmployeeBonusPaymentsTest {
    @isTest
    static void MonthlyEmployeeBonusPaymentsTest() {

        test.startTest ();
        MonthlyEmployeeBonusPayments testing = new MonthlyEmployeeBonusPayments();
        String chron = '0 0 10 1 *';        
        System.schedule('Test Sched', chron, testing);
        test.stopTest ();


        /*  BELOW CODE WAS SUPPOSED TO CREATE CARS AND TEST THE RESULT.
List<Car__c> dismantledCars = new List<Car__c>();
Contact tester = new Contact(Lastname='IamTester');
insert tester;
        for (Integer i; i<35; i++){
            dismantledCars.add(new Car__c(name='TestCar'+i, master__c=tester.id, Is_Dismantled__c=true,Dismantled_Date__c=Date.today()));
        }

test.startTest();
insert dismantledCars;
Test.stopTest();

Decimal bonuspayment=[select amount__c from Finance_Transaction__c where contact__c=tester.id AND type__c='Commission' limit 1];

System.assertEquals(350, bonuspayment);

    }
}
*/
    }
}
