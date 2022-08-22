trigger CheckContainerCapacity on Car_Part__c (before insert, before update) {
    if (Trigger.isInsert){
        CheckContainerCapacityHandler.insertedCheck((List<Car_Part__c>)Trigger.new);
    }
    else{
        CheckContainerCapacityHandler.updatedCheck((List<Car_Part__c>)Trigger.old ,(List<Car_Part__c>)Trigger.new);
    }
}