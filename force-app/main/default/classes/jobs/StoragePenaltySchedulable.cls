public class StoragePenaltySchedulable implements  Schedulable {
    
    public void execute (System.SchedulableContext sc) {
        List<Car__c> payList=[SELECT Id, Name, Storage_Cost__c, Penalty_Cost__c, Total_Cost__c FROM Car__c];
        List<Contact> conlist = [Select Id, Name, Email FROM Contact];
        
        Decimal allStorageCost= 0;
        Decimal allPenaltyCost= 0;
        
        for(Car__c n : paylist){
            if (n.Storage_Cost__c != null) {
                allStorageCost += n.Storage_Cost__c;
            }       
            if (n.Penalty_Cost__c != null) {
                allPenaltyCost += n.Penalty_Cost__c;
            }                                  
        }

        update payList;

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{};
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[]{conlist[0].Email};
        message.plainTextBody = 'All Penalty Cost: '+ allPenaltyCost + '  All Storage Cost:  ' + allStorageCost;
        messages.add(message);  
        Messaging.sendEmail(messages);        
    }
}