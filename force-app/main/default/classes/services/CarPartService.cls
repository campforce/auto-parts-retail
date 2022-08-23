public with sharing class CarPartService {

   /**
     * Method to create Finance transaction record based on selling Car Part.
     * 
     * @param oldMap old Car Parts 
     * @param newMap new Car Parts
     * @author canselagasiyeva 
     */
    public static void handleSell(Map<Id, Car_Part__c> oldMap, Map<Id, Car_Part__c> newMap) {
        List<Finance_Transaction__c> newFinanceTransactionList = new List<Finance_Transaction__c>();
        for(Car_Part__c part : newMap.values()){
            if(part.Is_Sold__c && (oldMap == null || !oldMap.get(part.Id).Is_Sold__c)){
               newFinanceTransactionList.add(new Finance_Transaction__c(Amount__c = part.Price__c, Car_Part__c = part.Id, Car__c = part.Car__c, Type__c = FinanceTransactionService.SELL_TYPE));
            }    
        }
        insert newFinanceTransactionList;
    }
} 