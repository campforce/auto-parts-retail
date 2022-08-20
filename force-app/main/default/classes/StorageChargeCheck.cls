public with sharing class StorageChargeCheck implements Database.Batchable<sObject>
{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        //Get all purchased cars
        String query= 'Select id, Purchase_Date__c From Car__c Where Purchase_Date__c != null';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        Integer count = 0;
        //Iterate purchased cars
        for (Car__c c : (List<Car__c>)scope)
        {
            //Get purchased date
            Date purchasedDate = date.newinstance(c.Purchase_Date__c.year(), c.Purchase_Date__c.month(), c.Purchase_Date__c.day());
            
            //Get today's date
            Date today = System.today();
            
            //Calculate diffence between purchased date and today's date
            Integer numberDaysDue = purchasedDate.daysBetween(today);
            Integer storageCharge = 0;

            //Calculate storage charge
            if (numberDaysDue == 4)
            {
                storageCharge = 5;
            }
            else if (numberDaysDue == 5)
            {
                storageCharge = 10;
            }
            else if (numberDaysDue == 6) 
            {
                storageCharge = 15;
            }
            else if (numberDaysDue > 6)
            {
                storageCharge = numberDaysDue * 25;
            }

            //Edit storage cost field
            if (storageCharge > 0)
            {
                c.Storage_Cost__c = storageCharge;
                count++;
            }

        }//for loop

        //Update records
        if (count > 0)
        {
            update scope;
        }
    }

    public void finish(Database.BatchableContext bc)
    {}
}
