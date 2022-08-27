 public class MailToManagerTriggerHandler {
            public static void SendEmailNotification(List<Container__c> containerLists){
                
            
         List<Container__c> containerlist = [SELECT Id, Name, (SELECT Name, Container__c, Id, Type__c, Car__c 
                                                            FROM Car_Parts__r), Account__c FROM Container__c];
            
            List<Car_Part__c> hcList = new  List<Car_Part__c>();
            List<Car_Part__c> engList = new  List<Car_Part__c>();
            for(Container__c container: containerlist){
                for(Car_Part__c carPart: container.Car_Parts__r){
                    if(carPart.Type__c=='Half Car'){
                        hcList.add(carPart);
                    }
                    else if(carPart.Type__c=='Engine'){
                        engList.add(carPart);
                    }
                }
            }
            if(hcList.size()==12 && engList.size()==45){
                system.debug('It is Fine');
              
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                List<String> address = new List<String>{'mesmebestwick@gmail.com'};
                    
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject('Container is ready to ship');
                mail.setplaintextbody('Tracking details for your container');
                mail.setToAddresses(address);
                emailList.add(mail);
                
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
                 
            }
          
            }
        }
                    
        
    

