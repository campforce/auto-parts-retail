trigger ContainerTrigger on Container__c (before insert, before update, before delete, after insert, after update, after delete) {
    new ContainerTriggerHandler().run();
}