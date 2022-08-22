public with sharing class CarService {
   
   /**
    * Approval process for the pulled auto parts
    * 
    * @param oldMap old car__c
    * @param newMap new car__c
    * @param recordID the record to approve 
    * @param approvalProcessName the approval process to use 
    * @author gulzatbaimyrzaeva
    */    
    public static void ApprovalProcess (Id recordID, String ApprovalProcessName, Id userId) {
        Approval.ProcessSubmitRequest processSubmitRequest=new Approval.ProcessSubmitRequest();
        
        processSubmitRequest.setObjectID(recordID);
        processSubmitRequest.setCommnet('Submitted for approval by apex code');
        processSubmitRequest.setProcessDefinitionNameOrId(approvalProcessName);
        processSubmitRequest.setSubmitterId(userId);
        processSubmitRequest.setSkipEntryCriteria(true);

        Approval.ProcessResult result = Approval.process(processSubmitRequest);   
        return result.isSuccess();
    }
    
   /**
    * @description       Starts a given approval process for the specified record,
    * assuming the submitting user is the apex execution context user.
    * @param recordId the record to approve 
    * @param approvalProcessName the approval process to use 
    */
    public Boolean startApprovalProcess(Id recordID, String approvalProcessName) {
      Id userID = UserInfo.getUserId();
    }

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
}

