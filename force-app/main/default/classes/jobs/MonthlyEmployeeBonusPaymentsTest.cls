
@isTest
public with sharing class MonthlyEmployeeBonusPaymentsTest {
    @isTest
    static void MonthlyEmployeeBonusPaymentsTest() {
        test.startTest ();
        MonthlyEmployeeBonusPaymentsSchedulable testing = new MonthlyEmployeeBonusPaymentsSchedulable();
        String chron = '0 0 0 3 9 ? 2022';        
        System.schedule('Test Sched', chron, testing);
        test.stopTest ();
    }
}