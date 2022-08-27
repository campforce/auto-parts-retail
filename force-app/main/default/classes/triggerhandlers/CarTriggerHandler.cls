public with sharing class CarTriggerHandler extends TriggerHandler {

    private List<Car__c> newCarList;
    private List<Car__c> oldCarList;
    private Map<Id, Car__c> newCarMap;
    private Map<Id, Car__c> oldCarMap;

    public CarTriggerHandler() {
        this.newCarList = (List<Car__c>) Trigger.new;
        this.oldCarList = (List<Car__c>) Trigger.old;
        this.newCarMap = (Map<Id, Car__c>) Trigger.newMap;
        this.oldCarMap = (Map<Id, Car__c>) Trigger.oldMap;
    }

    public override void beforeUpdate() {
        CarService.commissionCalculator(newCarList);
        CarService.feeSumEmailToCEO(newCarMap, oldCarMap);
        CarService.carTotalCost(newCarList);
        CarService.DistanceCalc(newCarList);
        CarService.valdiateCurrencyField(newCarMap, oldCarMap);
        CarService.handleDrivable(oldCarMap,newCarList);
        CarService.calculateTransportation(oldCarMap, newCarList);
    }
  
    public override void beforeInsert() {
        CarService.commissionCalculator(newCarList);
        CarService.carTotalCost(newCarList);
        CarService.DistanceCalc(newCarList);
        CarService.handleDrivable(null, newCarList);
        CarService.calculateTransportation(null, newCarList);
    }
    
    public override void afterInsert(){
        CarService.approvalProcess(newCarList,null);
    } 

    public override void afterUpdate(){
        CarService.approvalProcess(newCarList, oldCarMap);
        System.enqueueJob(new CurrencyQueueable(newCarList,oldCarMap));
    }
}
