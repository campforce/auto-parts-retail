trigger ContainerReleasedTrigger on Container__c (before update) {
    //Launch handler
    ContainerReleasedTriggerHandler.checkPayments(new Set<Container__c>((List<Container__c>)Trigger.new));
    
}