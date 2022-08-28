public class CarSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {            
            Car__c.Id,
            Car__c.Account__c,
            Car__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Car__c.SObjectType;
    }

    public List<Car__c> selectById(Set<Id> idSet) {
        return (List<Car__c>) selectSObjectsById(idSet);
    }
}