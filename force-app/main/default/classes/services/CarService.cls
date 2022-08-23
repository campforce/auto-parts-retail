public with sharing class CarService {

    /**
     * Method to calculate auction commissions according to price ranges.
     *
     * @param newList newly inserted, updates properties
     * @author GulnazAtabaeva
     */
    public static void commissionCalculator(List<Car__c> newList) {
        for (Car__c car : newList) {
            if (car.Car_Cost__c <= 1000) { //commission up to 1000$
                car.Comission__c = 170;
            } else if (car.Car_Cost__c <= 2000) { //commission btw 1000$ and 2000$
                car.Comission__c = 250;
            } else if (car.Car_Cost__c <= 5000) { //commission btw 2000$ and 5000$
                car.Comission__c = 300;
            } else if (car.Car_Cost__c <= 10000) { //comission btw 5000$ and 10000$
                car.Comission__c = 350;
            } else { //commission for price more than 10000$
                car.Comission__c = 400;
            }
        }
    }

    // @author Oleh, 
    public static void FeeSumEmailToCEO (List<Car__c> newList, List<Car__c> oldList);

    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{};
        for (Car__c car : newList) {
            if()
            if ((car.Storage_Cost__c + car.Penalty_Cost__c) <= 1000){

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[]{'oleh.chkh@gmail.com'};
            message.setSubject = new String []{'Too many fees here, boss'};
            message.plainTextBody = 'Hey,' + car.name 'has too many fees. Penaly charges exceed $1k. Cut $400 from the superwisors wage!';
            messages.add(message);
        }
    
         Messaging.sendEmail(messages);
    }
        
        
        
}
