public with sharing class LwcPdfGeneratorForCarPartsController {
    @AuraEnabled
    public static List<Car_Part__c> getCarParts(Id recordId){
        return [SELECT Id, Name, Price__c, Weight__c, Container__r.Name, Is_Sold__c, Is_Export__c, Car__r.Name FROM Car_Part__c WHERE Car__c =: recordId];
    }
}