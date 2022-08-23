public with sharing class CarService {
   
   /**
    * Approval process for the parts to be pulled if the status of the Car object is 'in the yard'.
    * 
    * @param oldMap old car__c
    * @param newMap new car__c
    * @author gulzatbaimyrzaeva
    */    
    public static void ApprovalProcess (list <Car__c> newCarList) {
        for(Car__c car:newCarList)
        if (car.Status__c=='In The Yard'){

        Approval.ProcessSubmitRequest req= new Approval.ProcessSubmitRequest();
        req.setComments('Submittng request for approvasl automatically using Trigger');
        req.setObjectId(car.ID);
        req.setNextApproverIds(new Id[] {car.Username.Id});
        //submit the approval request for the Car object 
        Approval.ProcessResult result =Approval.process(req);
        }
      }
    
    /**
     * Method to calculate total cost.
     *
     * @param newList newly inserted, updates cars
     * @author aysel
     */
    public static void carTotalCost(list <Car__c> newLists) {
      for(Car__c cob:newLists){
        if(cob.Total_Cost__c != null) {        
            if(cob.Penalty_Cost__c != null) {
                cob.Total_Cost__c += cob.Penalty_Cost__c;
            }
            if(cob.Storage_Cost__c != null) {
                cob.Total_Cost__c += cob.Storage_Cost__c;
            }
            if(cob.Comission__c != null) {
                cob.Total_Cost__c += cob.Comission__c;
            }
            if(cob.Car_Cost__c != null) {
                cob.Total_Cost__c += cob.Car_Cost__c;
            }
        }
      }
    }    

    /**
     * Method to calculate auction commissions according to price ranges.
     *
     * @param newList newly inserted, updates properties
     * @author GulnazAtabaeva
     */
    public static void commissionCalculator(List <Car__c> newList) {
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
}