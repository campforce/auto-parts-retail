public class FinanceTransactionTriggerHandler extends TriggerHandler {

    private List<Finance_Transaction__c> newFinanceTransactionList;
    private List<Finance_Transaction__c> oldFinanceTransactionList;
    private Map<Id, Finance_Transaction__c> newFinanceTransactionMap;
    private Map<Id, Finance_Transaction__c> oldFinanceTransactionMap;

    public FinanceTransactionTriggerHandler() {
        this.newFinanceTransactionList = (List<Finance_Transaction__c>) Trigger.new;
        this.oldFinanceTransactionList = (List<Finance_Transaction__c>) Trigger.old;
        this.newFinanceTransactionMap = (Map<Id, Finance_Transaction__c>) Trigger.newMap;
        this.oldFinanceTransactionMap = (Map<Id, Finance_Transaction__c>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        FinanceTransactionService.addRevenue(newFinanceTransactionList);

    }

    public override void afterUpdate(){
        FinanceTransactionService.UpdateCostFieldsofCar(newFinanceTransactionList);
    }

    public override void afterInsert(){
        FinanceTransactionService.UpdateCostFieldsofCar(newFinanceTransactionList);
    }


}