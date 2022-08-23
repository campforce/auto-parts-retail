public with sharing class StorageChargeCheckBatch implements Database.Batchable<sObject>{
   
    public Database.QueryLocator start(Database.BatchableContext bc){                
        return Database.getQueryLocator('SELECT id, Purchase_Date__c FROM Car__c WHERE Purchase_Date__c != null AND Is_Picked_Up__c = false');
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Car__c> carsToUpdate = new List<Car__c>();
        
        for (Car__c c : (List<Car__c>)scope){            
            Date purchasedDate = c.Purchase_Date__c.date();
            Date today = System.today();
            
            Integer numberDaysDue = purchasedDate.daysBetween(today);
            Decimal storageCharge = 0;

            if (numberDaysDue == 4){
                storageCharge = 5;
            } else if (numberDaysDue == 5){
                storageCharge = 10;
            } else if (numberDaysDue == 6){
                storageCharge = 15;
            } else if (numberDaysDue == 7){
                storageCharge = 25;
            } else if (numberDaysDue > 7){
                storageCharge = c.Storage_Cost__c + 25;
            }

            if (storageCharge > 0){
                c.Storage_Cost__c = storageCharge;
                carsToUpdate.add(c);
            }
        }
        update carsToUpdate;
    }

    public void finish(Database.BatchableContext bc){
    }
}