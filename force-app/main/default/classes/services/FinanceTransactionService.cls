public with sharing class FinanceTransactionService {
    public static final String SELL_TYPE = 'Sell';
    
    /**
     * Method update two fields in Cars object when in FinanceTransaction object chosen:
     *   Type 'Storage' -> 'Amount' from FinanTransaction add to field 'Storage Cost' in Cars object;
     *   Type 'Commissiom' -> 'Amount' from FinanTransaction add to field 'Commission' in Cars object;
     * @param CarList 
     * @author malika
     */
     public static void UpdateCostFieldsofCar(List<Finance_Transaction__c> NewList){
        List<Car__c> CarList = [SELECT Id, Name, Comission__c, Storage_Cost__c, 
                                (SELECT Type__c, Amount__c FROM Finance_Transactions1__r) 
                                FROM Car__c];
        List<Car__c> CarListNew = new List<Car__c>();
        for(Car__c Carn: CarList){
            for(Finance_Transaction__c Finn: Carn.Finance_Transactions1__r){
                if(Finn.Type__c=='Storage'){
                    Carn.Storage_Cost__c =  Carn.Storage_Cost__c + Finn.Amount__c;
                    CarListNew.add(Carn);
                }
                else if(Finn.Type__c=='Commission'){
                    Carn.Comission__c =  Carn.Comission__c + Finn.Amount__c ;
                    CarListNew.add(Carn);
                }
            }
        }
        update CarListNew;
    }
    
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
