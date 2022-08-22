/**
 * Created by omurzakov on 20.08.2022.
 */

@isTest
 public with sharing class CarServiceTest {

    static String approvalProcessName=[Select name FROM processdefinition LIMIT 1] [0].Name;

    @is@TestSetup
    static void testApprovalProcessPositive(){
        User notAdmin =TestFactory.createTestUser(true, 'Standart User');
        Car__c car =(Car__c)TestFactory.createSobject(new Car__c (name='Test car',Status__c='not In The Yard'), true);
        
        ApprovalProcessRecipes apr =new ApprovalprocessRecipes ();
        Boolean result = apr.startApprovalProcess(car.id, approvalProcessName);

        System.assert(result, 'expected to receive true');
        
    }
}