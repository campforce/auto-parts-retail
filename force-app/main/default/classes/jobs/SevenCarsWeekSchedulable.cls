
    /**
     * Scheduable batch method to check if the master dismantled more or less than 7 cars a week and to add according finance transaction
     * 
     * 
     * @author MartinCapek
     */


public with sharing class SevenCarsWeekSchedulable implements  Schedulable {
    
public void execute (schedulablecontext ctx){
   
    //list of aggregated accounts by dismantled cars *LAST_N_DAYS:6* containstoday + 6 days 7 in total, needs to be scheduled on Sunday, not monday to cover the week
    List <aggregateResult> below7 = [SELECT master__c, COUNT (id) FROM car__c WHERE Is_Dismantled__c = true AND Dismantled_Date__c = LAST_N_DAYS:6 GROUP BY Master__c Having count (id) <7]; 
    List <aggregateResult> above7 = [SELECT master__c, COUNT (id) FROM car__c WHERE Is_Dismantled__c = true AND Dismantled_Date__c = LAST_N_DAYS:6  GROUP BY Master__c Having count (id)>7]; 
    
    //new empty list for transactions
    List <Finance_Transaction__c> financeList = new list <finance_transaction__c>();
    
    //loop throught the results to to create new transactions *(string)b7.get('master__c')* transforms master__c object in to the string usable as Id for contact 
    For (aggregateResult b7:below7){
        financeList.add(new Finance_Transaction__c  (Contact__c=(string)b7.get('master__c'), amount__C=-200,Type__c='Commission'));
    }
    For (aggregateResult a7:above7){
        financeList.add(new Finance_Transaction__c  (Contact__c=(string)a7.get('master__c'), amount__C=+200,Type__c='Commission'));
       
    }
    
    insert financeList;
    }
}
