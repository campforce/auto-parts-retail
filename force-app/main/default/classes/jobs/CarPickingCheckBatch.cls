public class CarPickingCheckBatch implements Database.Batchable<Sobject>, Schedulable {
    
    public void execute(SchedulableContext  sc) {
        CarPickingCheckBatch batch = new CarPickingCheckBatch();
        Database.executeBatch(batch, 200);
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        String condition = '(SELECT Driver__c FROM Car__c WHERE Is_Picked_Up__c = FALSE AND Is_Paid__c = TRUE AND Purchase_Date__c < LAST_N_DAYS:2 AND Purchase_Date__c != NULL)';
        String subquery = '(SELECT Name, Purchase_Date__c FROM Cars__r WHERE Purchase_Date__c != NULL)';
        
        return Database.getQueryLocator('SELECT FirstName, Email, ' + subquery + ' FROM Contact WHERE Id IN ' + condition);
     }    

    public void execute(Database.BatchableContext info, List<Contact> scope){     
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{};
        
        for(Contact driver : scope){             
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[]{driver.Email};
            message.setSubject('Reminder for picking up car');
            message.plainTextBody = 'Hello ' + driver.FirstName +',\nyou are getting this message, because the following cars: \n\n';
            
            for(Car__c car : driver.Cars__r) {
                message.plainTextBody += 'Name: ' + car.Name + ' | Purchase date: ' + car.Purchase_Date__c + '\n';
            }   

            message.plainTextBody += '\nThis is kindly reminder, because we are getting penalties for storage in auction. \nKing regards,';
            messages.add(message);             
        }        
        Messaging.sendEmail(messages);  
    }     

    public void finish(Database.BatchableContext info){     
    } 
}