/*
* @author Dastan
*
* @date 2022-08-26
*
* @description Method to compare cost of the car when it was bought and when it was sold in AED 
*/
public with sharing class CurrencyQueueable implements Queueable, Database.AllowsCallouts {
    public static String targetCurrency = 'AED';
    public static String sourceCurrency = 'USD';

    private Set<Id> carIds;

    public CurrencyQueueable(List<Car__c> newCars, Map<Id, Car__c> oldMap) {
        this.carIds = new Set<Id>();
        for(Car__c c : newCars){
            if((c.Status__c == 'Done' && oldMap.get(c.Id).Status__c != 'Done') && c.Currency__c == 'AED'){
                carIds.add(c.Id);
            }
        }
    }
    public void execute(QueueableContext context){        
        String carBoughtDate;
        String carBoughtDay;
        String carBoughtMonth;
        String carBoughtYear;
        String carSoldDate;
        String amount;
        List<Car__c> carsToUpdate = new List<Car__c>();
        List<Car__c> soldCars = [SELECT Id, Car_Cost__c, Purchase_Date__c FROM Car__c WHERE Id =: carIds];
        for(Car__c c : soldCars){
            carBoughtDay = String.valueOf(c.Purchase_Date__c.day());
            if(!carBoughtDay.startsWith('0') && carBoughtDay.length() == 1){
                carBoughtDay = '0' + carBoughtDay;
            }
            carBoughtMonth = String.valueOf(c.Purchase_Date__c.month());
            if(!carBoughtMonth.startsWith('0') && carBoughtMonth.length() == 1){
                carBoughtMonth = '0' + carBoughtMonth;
            }
            carBoughtYear = String.valueOf(c.Purchase_Date__c.year());
            carBoughtDate = carBoughtYear + '-' +carBoughtMonth + '-' + carBoughtDay;
            carSoldDate = String.valueOf(Date.today()).removeEnd(' 00:00:00');
            amount = String.valueOf(c.Car_Cost__c);

            Double boughtCarAmount = CurrencyConverterIntegration.convertAmount(sourceCurrency, targetCurrency, amount, carBoughtDate);

            Double soldCarAmount = CurrencyConverterIntegration.convertAmount(sourceCurrency, targetCurrency, amount, carSoldDate);

            c.How_much_we_gain_lost__c = String.valueOf(soldCarAmount - boughtCarAmount);
            carsToUpdate.add(c);
        } 
        update carsToUpdate;
    }
}
