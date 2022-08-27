@isTest
public class SevenCarsWeekSchedulableTest {
    @isTest
    static void finTransTest() {

       
        //given
        
        List<Car__c> dismantledCars = new List<Car__c>();
        List<Car__c> dismantledCars2 = new List<Car__c>();
   
        //create contacts for above nad below treshold of 7 cars
        Contact mBelow = new Contact(Lastname='mBelow');
        Contact mAbove = new Contact(Lastname='mAbove');
        
        insert mBelow;
        insert mAbove;
   
        for (Integer i=1; i<3; i++){
          dismantledCars.add(new Car__c(name='car1'+i,driver__c=mBelow.id, master__c=mBelow.id, Is_Dismantled__c=true,Dismantled_Date__c=Date.today()-1));
        }
       insert dismantledCars;
        
        for (Integer i=1; i<9; i++){
            dismantledCars2.add(new Car__c(name='carA'+i,driver__c=mabove.id, master__c=mabove.id, Is_Dismantled__c=true,Dismantled_Date__c=Date.today()));
        }
        insert dismantledCars2;

        //when
             
        system.test.starttest();
        //SchedulableContext sc = null;
        //SevenCarsWeekSchedulable tst = new SevenCarsWeekSchedulable();
        //tst.execute(sc);

          
      
        SevenCarsWeekSchedulable s =new SevenCarsWeekSchedulable();
        s.execute(null) ;

        system.test.stopTest();

       


        //then
        
      Finance_Transaction__c fBelow  = [SELECT contact__c, amount__c FROM Finance_Transaction__c WHERE contact__c =: mBelow.id limit 1 ];
      Finance_Transaction__c fAbove  = [SELECT contact__c, amount__c FROM Finance_Transaction__c WHERE contact__c=:  mAbove.id limit 1];
       
     System.assertEquals(-200, fBelow.amount__C);
     System.assertEquals(fAbove.amount__C,200);
  
    }
}
