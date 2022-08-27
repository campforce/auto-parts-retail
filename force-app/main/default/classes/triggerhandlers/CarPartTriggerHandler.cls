public with sharing class CarPartTriggerHandler extends TriggerHandler {

    private List<Car_Part__c> newCarPartList;
    private List<Car_Part__c> oldCarPartList;
    private Map<Id, Car_Part__c> newCarPartMap;
    private Map<Id, Car_Part__c> oldCarPartMap;

    public CarPartTriggerHandler() {
        this.newCarPartList = (List<Car_Part__c>) Trigger.new;
        this.oldCarPartList = (List<Car_Part__c>) Trigger.old;
        this.newCarPartMap = (Map<Id, Car_Part__c>) Trigger.newMap;
        this.oldCarPartMap = (Map<Id, Car_Part__c>) Trigger.oldMap;
    }

    public override void beforeUpdate() {
        CarPartService.handleSell(oldCarPartMap, newCarPartMap);
        CarPartService.loadToContainer(oldCarPartList, newCarPartList);
        CarPartService.validateContainerField(newCarPartList);
    }

    public override void afterInsert() {
        CarPartService.handleSell(oldCarPartMap, newCarPartMap);
    }

    public override void beforeInsert() {
        CarPartService.loadToContainer(newCarPartList);
        CarPartService.validateContainerField(newCarPartList);
    }
}