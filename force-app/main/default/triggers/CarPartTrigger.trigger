trigger CarPartTrigger on Car_Part__c (before insert, before update, before delete, after insert, after update, after delete) {
    new CarPartTriggerHandler().run();
}