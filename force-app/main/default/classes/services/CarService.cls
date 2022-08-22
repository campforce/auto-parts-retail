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
    
    public static void ApprovalProcess (
    ID recordID,
    String ApprovalProcessName,
    Id userId
    ) {
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
public Boolean startApprovalProcess(Id recordID, String approvalProcessName){
    ID userID =UserInfo.getUserId();
}
}

