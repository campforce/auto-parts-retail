public with sharing class ContainerService {

    public static void checkPayments(Set<Container__c> updatedContainers) {
        /*Since Trigger.new may contain more than 1 object, geting all car parts of updated containers where parent car
        object's isPaid field equals to False*/
        List<Car_Part__c> allCarParts = [Select id, Container__c, Car__c From Car_Part__c WHERE Car__r.Is_Paid__c = False AND Container__c in :updatedContainers];

        //Map to storage sorted car parts by containers
        Map<Container__c, List<Car_Part__c>> sortedCarParts = new Map<Container__c, List<Car_Part__c>>();
        
        //Set To storage updated containers
        Set<Container__c> releasedContainers = new Set<Container__c>();

        //Sorting car parts by released containers
        for (Container__c c : updatedContainers){
            if (c.Status__c == 'Release'){
                List<Car_Part__c> carParts = new List<Car_Part__c>();

                for (Integer i = 0; i < allCarParts.size(); i++){
                    if (allCarParts[i].Container__c == c.id){
                        carParts.add(allCarParts[i]);
                        allCarParts.remove(i);
                    }
                }

                sortedCarParts.put(c, carParts);
                releasedContainers.add(c);
            }
        }

        //If container has more than 1 unpaid car part, prevents to update
        for (Container__c c : releasedContainers){
            if (sortedCarParts.get(c).size() > 0){
                c.addError('We can\'t release containers with unpaid car parts!!!');
            }
        }
    }
}