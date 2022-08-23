/**
 * @author Dastan
 * @date 2022-08-23
 *
 * @description Controller for lwcReportForMasters component
 */
public with sharing class LwcReportForMastersController {
    /**
     * @author Dastan 
     * @date 2022-08-23
     * 
     * @description this method will count and return number of related cars for contact master record
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getCarQuantity(Id recordId){
        return [SELECT COUNT() FROM Car__c WHERE Master__c =: recordId AND Is_Dismantled__c = true AND CreatedDate = LAST_N_DAYS:30];
    }
    /**
     * @author Dastan 
     * @date 2022-08-23
     * 
     * @description this method will return all car parts that are related to respective car
     */
    @AuraEnabled(cacheable=true)
    public static List<DataTableWrapper> getRelatedCarParts(Id recordId){
        Set<Id> carIds = new Set<Id>();
        List<Car__c> relatedCars = [SELECT Id, Master__c FROM Car__c WHERE Master__c =: recordId AND Is_Dismantled__c = true];
        if(relatedCars.size() > 0){
            for(Car__c c : relatedCars){
                carIds.add(c.Id);
            }
        }
        List<Car_Part__c> relatedCarParts = [SELECT Id, Name, Car__r.Name, Price__c FROM Car_Part__c WHERE Car__c =: carIds];

        List<DataTableWrapper> response = new List<DataTableWrapper>();
        for(Car_Part__c cp : relatedCarParts){
            DataTableWrapper obj = new DataTableWrapper();
            obj.cpId = cp.Id;
            obj.carPartName = cp.Name;
            obj.carPartUrl = '/' + cp.Id;
            obj.carName = cp.Car__r.Name;
            obj.carUrl = '/' + cp.Car__c;
            obj.price = cp.Price__c;
            response.add(obj);
        }
        return response;
    }
    /**
     * @author Dastan 
     * @date 2022-08-23
     * 
     * @description wrapper...
     */
    public class DataTableWrapper {
        @AuraEnabled
        public Id cpId {get;set;}
        @AuraEnabled
        public String carPartName {get;set;}
        @AuraEnabled
        public String carPartUrl {get;set;}
        @AuraEnabled
        public String carUrl {get;set;}
        @AuraEnabled
        public String carName {get;set;}
        @AuraEnabled
        public Decimal price {get;set;}
    }
}