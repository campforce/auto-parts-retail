public class ContainerSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {            
            Container__c.Id,
            Container__c.Account__c,
            Container__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Container__c.SObjectType;
    }

    public List<Container__c> selectById(Set<Id> idSet) {
        return (List<Container__c>) selectSObjectsById(idSet);
    }
}