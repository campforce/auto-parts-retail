@isTest
public class CheckPenaltyTest {
    @testSetup  
    static void dataSetup(){
        Contact newContact = new Contact(LastName='ContactTest1');
        Contact newContact2 = new Contact(LastName='ContactTest2');
        insert newContact;
        insert newContact2;  
        
        List<Car__c> carList =new List<Car__c>();
        carList.add(new Car__c(Name = 'TEST1',Driver__c = newContact.Id,  Is_Paid__c=false,  Purchase_Date__c= System.today() + 11));
        carList.add(new Car__c(Name = 'TEST2',Driver__c = newContact2.Id, Is_Paid__c=false,  Purchase_Date__c= System.today() + 4));
        
        insert carList;
    }
    @isTest
    static void testM() {    
        Test.startTest();
        CheckIsPaid n = new CheckIsPaid(); 
        String cronExp = '0 0 9 * * ?';
        String jobId = System.Schedule('PenaltyAdd Schedule 3', cronExp, n);   
        
        Database.executeBatch(n, 10);     
        Test.stopTest();
        
        Car__c list1 = [SELECT Id, Name, Driver__c, Is_Paid__c, Purchase_Date__c, Penalty_Cost__c 
                        FROM Car__c where Name= 'TEST1'];
        Car__c list2 = [SELECT Id, Name, Driver__c, Is_Paid__c, Purchase_Date__c, Penalty_Cost__c 
                        FROM Car__c where Name= 'TEST2'];  
        
        system.assertEquals(300,list1.Penalty_Cost__c, 'Failed');
        system.assertEquals(50,list2.Penalty_Cost__c, 'Failed');    
        
    }     
}