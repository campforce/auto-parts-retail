public with sharing class LwcCarSoldPartChartController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getStatistics(Id recordId) {
        Map<String, Integer> dataset = new Map<String, Integer>();
        for(AggregateResult record : [SELECT Type__c, COUNT(Id) Total FROM Car_Part__c WHERE is_Sold__c=true AND Car__c=:recordID GROUP BY Type__c]) {
            dataset.put((String) record.get('Type__c'), (Integer) record.get('Total'));
        }
        return dataset;  
    }
}