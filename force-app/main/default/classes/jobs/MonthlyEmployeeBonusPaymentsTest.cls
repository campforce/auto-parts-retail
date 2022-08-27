
@isTest
public with sharing class MonthlyEmployeeBonusPaymentsTest {
    @isTest
    static void MonthlyEmployeeBonusPaymentsTest() {
        test.startTest ();
        MonthlyEmployeeBonusPayments testing = new MonthlyEmployeeBonusPayments();
        String chron = '0 0 0 3 9 ? 2022';        
        System.schedule('Test Sched', chron, testing);
        test.stopTest ();
    }
}