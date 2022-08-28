public class FinanceTransactionSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {            
            Finance_Transaction__c.Id,
            Finance_Transaction__c.Account__c,
            Finance_Transaction__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Finance_Transaction__c.SObjectType;
    }

    public List<Finance_Transaction__c> selectById(Set<Id> idSet) {
        return (List<Finance_Transaction__c>) selectSObjectsById(idSet);
    }
}