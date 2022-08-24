public with sharing class StorageChargeCheckBatch implements Database.Batchable<sObject>{
   
    public Database.QueryLocator start(Database.BatchableContext bc){
        //Get all purchased cars
        String query= 'Select id, Purchase_Date__c From Car__c Where Purchase_Date__c != null AND Is_Picked_Up__c = false';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Car__c> carsToUpdate = new List<Car__c>();

        //Iterate purchased cars
        for (Car__c c : (List<Car__c>)scope){
            //Get purchased date
            Date purchasedDate = c.Purchase_Date__c.date();
            
            //Get today's date
            Date today = System.today();
            
            //Calculate diffence between purchased date and today's date
            Integer numberDaysDue = purchasedDate.daysBetween(today);
            Decimal storageCharge = 0;

            //Calculate storage charge
            if (numberDaysDue == 4){
                storageCharge = 5;
            }
            else if (numberDaysDue == 5){
                storageCharge = 10;
            }
            else if (numberDaysDue == 6){
                storageCharge = 15;
            }
            else if (numberDaysDue == 7){
                storageCharge = 25;
            }
            else if (numberDaysDue > 7){
                storageCharge = c.Storage_Cost__c + 25;
            }

            //Update storage cost field
            if (storageCharge > 0){
                c.Storage_Cost__c = storageCharge;
                carsToUpdate.add(c);
            }

        }//for loop

        //Update records
        if (carsToUpdate.size() > 0){
            update carsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc){
    }
}