@IsTest(SeeAllData=false)
private class CarPickingCheckBatchTest {

    @IsTest
    static void carPickingCheckBatchPositiveTest() {
        //given
        Contact driver = new Contact(LastName = 'Bob', Email = 'test.emai@driver.com');
        insert driver;
        insert new Car__c(Driver__c = driver.Id, Is_Paid__c = true, Purchase_Date__c = System.today().addDays(-10), Is_Picked_Up__c = false);

        //when
        Test.startTest();
        CarPickingCheckBatch batch = new CarPickingCheckBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();        
    }
}
