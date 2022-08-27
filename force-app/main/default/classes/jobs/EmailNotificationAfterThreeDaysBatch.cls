public with sharing class EmailNotificationAfterThreeDaysBatch implements Database.Batchable<SObject>, Schedulable {

 /**
     * Method to send email notification on the 3 day if the car has not paid.
     *
     * @param newList newly inserted, updates cars
     * @author gulzatbaimyrzaeva 
     */
    
    public void execute(System.SchedulableContext sc){
        EmailNotificationAfterThreeDaysBatch batch = new EmailNotificationAfterThreeDaysBatch();
             Database.executeBatch(batch, 200);
         }
    
         public Database.QueryLocator start(Database.BatchableContext bc) {
    
             return Database.getQueryLocator('SELECT Id, Is_Paid__c, Purchase_Date__c FROM Car__c Where Is_Paid__c=false');
         }
    
         public void execute(Database.BatchableContext bc, List<Car__c> cars) {         
             Map<Id, Car__c> carMap = new Map<Id, Car__c>(cars);
             List<Car__c> carList = [Select Id, is_Paid__c, Purchase_Date__c From Car__c Where Id IN: carMap.keySet()];
           
             //Iterate purchased cars
            for (Car__c c : carList){
                //Get purchased date
                Date purchasedDate = c.Purchase_Date__c.date();
                
                //Get today's date
                Date today = System.today();
                
                //Calculate diffence between purchased date and today's date
                Integer numberDaysDue = purchasedDate.daysBetween(today);
                
                List<Car__c> sortedCarList= new List <Car__c>();
                if (numberDaysDue>3){
                   sortedCarList.add(c);
                }
                       
             if(sortedCarList.size()>0){
                     Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{};
                     for(Car__c car : carList) {
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     message.toAddresses = new String[]{'gulzatmamasydyk@gmail.com'};
                     message.plainTextBody = 'Hello, dear our Customer ' + ' you didn\'t pay your purchase on time. Please pay your purchase on time.';
                     messages.add(message);
                 System.debug('');
                 }                
                     Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    
             }        
            } 
         } 
         public void finish(Database.BatchableContext bc) {} 
    }