public class StoragePenaltyClasess implements  Schedulable {
    
    public void execute (System.SchedulableContext sc) {
        list<car__c>paylist=[SELECT Id, Name, Storage_Cost__c, Penalty_Cost__c, Total_Cost__c FROM Car__c];
        List<Contact> conlist = [Select id, name, Email from Contact ];
        decimal allStorageCost= 0;
        decimal allPenaltyCost= 0;
        
        for(car__c n:paylist){             
            allStorageCost= n.Storage_Cost__c + allStorageCost;                  
            allPenaltyCost= allPenaltyCost+n.Penalty_Cost__c;
            n.Total_Cost__c= +n.Penalty_Cost__c+ n.Storage_Cost__c;
            
        }
        update paylist;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{};
            
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.toAddresses = new String[]{conlist[0].Email};
             message.plainTextBody = 'All Penalty Cost: '+allPenaltyCost+'  All Storage Cost:  '+allStorageCost;
              messages.add(message);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
    }
}