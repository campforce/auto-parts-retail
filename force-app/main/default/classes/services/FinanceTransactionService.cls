public with sharing class FinanceTransactionService {
    
    public static final String SELL_TYPE = 'Sell';
    /**
     * When payment for sold Car Parts comes, method adds amount to revenue amount on Car.
     *     
     * @param newList new inserted Finance_Transaction__c record
     * @author canselagasiyeva 
     */
    public static void addRevenue(List<Finance_Transaction__c> newList) {   
        Set<Id> carIds = new Set<Id>();
        
        for(Finance_Transaction__c payment : newList) {
            carIds.add(payment.Car__c);
        } 
        
        Map<Id, Car__c> mapCars = new Map<Id, Car__c>([SELECT Id, Revenue__c FROM Car__c WHERE Id IN :carIds]);
        for(Finance_Transaction__c payment : newList) {
            if (payment.Type__c == SELL_TYPE && payment.Car_Part__c != null && payment.Car__c != null) {                                            
                if(mapCars.get(payment.Car__c).Revenue__c == null) {
                    mapCars.get(payment.Car__c).Revenue__c = payment.Amount__c;
                } else {
                    mapCars.get(payment.Car__c).Revenue__c += payment.Amount__c;
                }
            }
        }
        update mapCars.values();
    }
}
