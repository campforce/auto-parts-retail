trigger CarTrigger on Car__c (before insert, before update, before delete, after insert, after update, after delete) {
    new CarTriggerHandler().run();
}