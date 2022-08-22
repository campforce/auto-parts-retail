public with sharing class CheckContainerCapacityHandler {
    public static void insertedCheck(List<Car_Part__c> carParts){
        List<Container__c> containers = new List<Container__c>();
        Set<id> containerIds = new Set<id>();
        for (Car_Part__c cp : carParts){
            containerIds.add(cp.Container__c);
        }

        Map<id, Container__c> containersMap = new Map<id, Container__c>(
            [Select Capacity__c From Container__c Where id in :containerIds]);
        
        for (Car_Part__c cp : carParts){
            if (cp.Container__c != null){
                if (containersMap.get(cp.Container__c).Capacity__c == null){
                    System.debug('Null');
                    Container__c container = new Container__c(
                        id = cp.Container__c,
                        Capacity__c = cp.Weight__c);
                    containers.add(container);
                }
                else{
                    System.debug('Not Null');
                    if (containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c <= 44000){
                        Container__c container = new Container__c(
                            id = cp.Container__c,
                            Capacity__c = containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c);
                    containers.add(container);
                    }
                    else{
                        cp.addError('Container is full');
                    }
                }
            }
        }

        update containers;
    }

    public static void updatedCheck(List<Car_Part__c> oldCarParts, List<Car_Part__c> newCarParts){
        List<Car_Part__c> cpWithoutContainer = new List<Car_Part__c>();
        List<Car_Part__c> newCpWithContainer = new List<Car_Part__c>();
        List<Car_Part__c> oldCpWithContainer = new List<Car_Part__c>();

        for (Integer i = 0; i < oldCarParts.size(); i++){
            if (oldCarParts[i].Container__c == null && newCarParts[i].Container__c != null){
                cpWithoutContainer.add(newCarParts[i]);
            }
            else{
                if (oldCarParts[i].Weight__c == null){
                    cpWithoutContainer.add(newCarParts[i]);
                }
                else if (oldCarParts[i].Weight__c != newCarParts[i].Weight__c){
                    oldCpWithContainer.add(oldCarParts[i]);
                    newCpWithContainer.add(newCarParts[i]);
                }
            }
        }

        if (cpWithoutContainer.size() > 0){
            insertedCheck(cpWithoutContainer);
        }
        if (newCpWithContainer.size() > 0){

            List<Container__c> containers = new List<Container__c>();
            Set<id> containerIds = new Set<id>();
            for (Car_Part__c cp : newCpWithContainer){
                containerIds.add(cp.Container__c);
            }
    
            Map<id, Container__c> containersMap = new Map<id, Container__c>(
                [Select Capacity__c From Container__c Where id in :containerIds]);
            
            for (Integer i = 0; i < newCpWithContainer.size(); i++){
                if (newCpWithContainer[i].Container__c != null){
                    System.debug('Updated weight');
                    if (containersMap.get(newCpWithContainer[i].Container__c).Capacity__c  - oldCpWithContainer[i].Weight__c + newCpWithContainer[i].Weight__c <= 44000){
                        Container__c container = new Container__c(
                            id = newCpWithContainer[i].Container__c,
                            Capacity__c = containersMap.get(newCpWithContainer[i].Container__c).Capacity__c - oldCpWithContainer[i].Weight__c + newCpWithContainer[i].Weight__c);
                        containers.add(container);
                    }
                    else{
                        newCpWithContainer[i].addError('Container is full');
                    }
                }
            }
    
            update containers;
        }
    }
}
