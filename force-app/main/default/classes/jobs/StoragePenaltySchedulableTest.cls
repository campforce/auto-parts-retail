@isTest
public class StoragePenaltySchedulableTest {
    
    @TestSetup
    static void setup (){
        List<Contact> conlist = new  List<Contact>();
        conlist.add(new Contact( LastName = 'Test  Contact 1', Email = 'bektur2130@gmail.com'));
        conlist.add(new Contact( LastName = 'Test  Contact 2', Email = 'bektur2130@gmail.com'));
        conlist.add(new Contact( LastName = 'Test  Contact 3', Email = 'bektur2130@gmail.com'));
        insert conlist;
        
        list<car__c> newcarlist=new list<car__c>();
        newcarlist.add(new car__c(name='test1', driver__c=conlist[0].ID, Storage_Cost__c=60,  Penalty_Cost__c = 60 ));
        newcarlist.add(new car__c(name='test2', driver__c=conlist[1].ID, Storage_Cost__c=70,  Penalty_Cost__c = 60 ));
        newcarlist.add(new car__c(name='test3', driver__c=conlist[2].ID, Storage_Cost__c=90,  Penalty_Cost__c = 60 ));
        insert newcarlist;
    }

    @isTest
    static void  testM(){
        Test.startTest();
        String cronExp = '0 0 9 * * ?';
        String jobId = System.Schedule('Storage Penalty Name', cronExp, new StoragePenaltySchedulable());        
        Test.stopTest();

        List<car__c> carList = [SELECT Id, Name, Storage_Cost__c, Penalty_Cost__c, Total_Cost__c FROM Car__c];
        System.assertEquals(120, carList[0].Storage_Cost__c + carList[0].Penalty_Cost__c);
    }
}