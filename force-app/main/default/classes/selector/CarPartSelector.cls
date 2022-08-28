public class CarPartSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {            
            Car_Part__c.Id,            
            Car_Part__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Car_Part__c.SObjectType;
    }

    public List<Car_Part__c> selectById(Set<Id> idSet) {
        return (List<Car_Part__c>) selectSObjectsById(idSet);
    }
}