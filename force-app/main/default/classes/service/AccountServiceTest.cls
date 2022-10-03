@IsTest(SeeAllData=false)
private class AccountServiceTest {

    @isTest
    static void phoneTest(){
      Account acc= new Account(Name='Test Phone Filed');
      insert acc;
      
      Account accCreated = [Select Name, Phone from Account];
        
      system.assertEquals('0998 999 999', accCreated.Phone); 
        
    }
}