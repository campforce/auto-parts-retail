/**
 * Scheduable batch method to check if the master dismantled more or less than 7 cars a week and to add according finance transaction
 * 
 * 
 * @author MartinCapek
 */
public with sharing class SevenCarsWeekSchedulable implements Schedulable {

    public void execute(SchedulableContext ctx) {
        //list of aggregated accounts by dismantled cars *LAST_N_DAYS:6* containstoday + 6 days 7 in total, needs to be scheduled on Sunday, not monday to cover the week
        List <AggregateResult> below7 = [SELECT Master__c, COUNT (Id) FROM Car__c WHERE Is_Dismantled__c = TRUE AND Dismantled_Date__c = LAST_N_DAYS:6 GROUP BY Master__c HAVING COUNT (Id) < 7];
        List <AggregateResult> above7 = [SELECT Master__c, COUNT (Id) FROM Car__c WHERE Is_Dismantled__c = TRUE AND Dismantled_Date__c = LAST_N_DAYS:6 GROUP BY Master__c HAVING COUNT (Id) > 7];

        //new empty list for transactions
        List<Finance_Transaction__c> financeList = new List<Finance_Transaction__c>();

        //loop through the results to to create new transactions *(String)b7.get('Master__c')* transforms Master__c object in to the String usable as Id for contact
        for (AggregateResult b7 : below7) {
            financeList.add(new Finance_Transaction__c (Contact__c = (String) b7.get('Master__c'), Amount__c = -200, Type__c = 'Commission'));
        }
        for (AggregateResult a7 : above7) {
            financeList.add(new Finance_Transaction__c (Contact__c = (String) a7.get('Master__c'), Amount__c = +200, Type__c = 'Commission'));
        }

        insert financeList;
    }
}
