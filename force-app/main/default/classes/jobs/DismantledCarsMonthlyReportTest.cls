@isTest
public with sharing class DismantledCarsMonthlyReportTest {
    @isTest static void testReport(){
        test.startTest ();
        DismantledCarsMonthlyReport myClass = new DismantledCarsMonthlyReport();   
        String chron = '0 0 10 * * ?';        
        System.schedule('Test Sched', chron, myClass);
        test.stopTest ();
    }
}
