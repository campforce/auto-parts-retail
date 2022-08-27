public with sharing class FinanceTransactionService {

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
}
