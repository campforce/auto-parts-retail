@IsTest(SeeAllData=false)
private class AccountServiceTest {

    @IsTest
    static void demonstrativeMethodTest() {
        insert new Account(Name = 'test');
    }
}