public with sharing class CheckContainerCapacityHandler {
    //Method to check inserted records
    public static void insertedCheck(List<Car_Part__c> carParts){
        //List to store containers to update Capacity__c
        List<Container__c> containers = new List<Container__c>();

        //Set of IDs of containers
        Set<id> containerIds = new Set<id>();
        //Get container ids from car parts
        for (Car_Part__c cp : carParts){
            containerIds.add(cp.Container__c);
        }
        //Get containers of updated car parts
        Map<id, Container__c> containersMap = new Map<id, Container__c>(
            [Select Capacity__c From Container__c Where id in :containerIds]);
        //Iterate through car parts
        for (Car_Part__c cp : carParts){
            //Do smth if car part's Container__c field is not null
            if (cp.Container__c != null){
                //If container's capacity is null means container has no car parts in it
                //we just add car part to container and update capacity of container with weight of car part
                if (containersMap.get(cp.Container__c).Capacity__c == null){
                    Container__c container = new Container__c(
                        id = cp.Container__c,
                        Capacity__c = cp.Weight__c);
                    containers.add(container);
                }
                //If container's capacity is not null means container has at least one car part
                else{
                    //Check if this car part is fit to container using weight of car part
                    if (containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c <= 44000){
                        Container__c container = new Container__c(
                            id = cp.Container__c,
                            Capacity__c = containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c);
                    containers.add(container);
                    }
                    //Else we prevent adding car part to the container since it's full
                    else{
                        cp.addError('Container is full');
                    }
                }
            }
        }

        update containers;
    }

    //Method to check updated records
    public static void updatedCheck(List<Car_Part__c> oldCarParts, List<Car_Part__c> newCarParts){
        //List to store car parts which were without container before updated
        List<Car_Part__c> cpWithoutContainer = new List<Car_Part__c>();
        //List to store car parts which were with container.
        //Since car parts with container included in container already
        //We have to calculate the capacity of the container using data from old version
        List<Car_Part__c> newCpWithContainer = new List<Car_Part__c>();
        List<Car_Part__c> oldCpWithContainer = new List<Car_Part__c>();

        //Using size of oldCarParts because it's equal to newCarParts size
        //so doesn't matter which list's size we will use
        for (Integer i = 0; i < oldCarParts.size(); i++){
            //Get car parts without containers before updated
            if (oldCarParts[i].Container__c == null && newCarParts[i].Container__c != null){
                cpWithoutContainer.add(newCarParts[i]);
            }
            else{
                //If car part had container before update, we check if it's weight were null before updated
                if (oldCarParts[i].Weight__c == null){
                    cpWithoutContainer.add(newCarParts[i]);
                }
                //If it's weight was not null before updated we check if it was changed
                else if (oldCarParts[i].Weight__c != newCarParts[i].Weight__c){
                    oldCpWithContainer.add(oldCarParts[i]);
                    newCpWithContainer.add(newCarParts[i]);
                }
            }
        }
        //If we have updated car parts without containers or with null weight before updated 
        //we just use logic for inserted containers since it's similar situation
        if (cpWithoutContainer.size() > 0){
            insertedCheck(cpWithoutContainer);
        }
        //If we have updated car parts with containers before updated
        //And which weight was changed
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
                    //We subtract old weight from containers capacity then we add new weight
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
