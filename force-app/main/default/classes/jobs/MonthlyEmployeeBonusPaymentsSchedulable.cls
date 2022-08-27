public with sharing class MonthlyEmployeeBonusPaymentsSchedulable implements Schedulable{
    public void execute (SchedulableContext ctx) {

        List<AggregateResult> employeeCarsDismantled=[SELECT Master__c FROM Car__c WHERE Dismantled_Date__c = LAST_N_MONTHS:1 and Is_Dismantled__c=true GROUP BY Master__c HAVING COUNT(Id) > 30];
       
        List<Finance_Transaction__c> bonuspayments = new List<Finance_Transaction__c>();
        
        for (AggregateResult items:employeeCarsDismantled){
            bonuspayments.add(new Finance_Transaction__c(Contact__c=(String)items.get('Master__c'), Type__c='Commission', Amount__c=350));
   
        }

        
        insert bonuspayments;
    }
}

