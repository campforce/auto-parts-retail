trigger FinanceTransactionTrigger on Finance_Transaction__c (before insert) {
    new FinanceTransactionTriggerHandler().run();
}