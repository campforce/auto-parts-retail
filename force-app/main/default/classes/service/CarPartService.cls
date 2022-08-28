public with sharing class CarPartService {

    /**
      * Method to create Finance transaction record based on selling Car Part.
      *
      * @param oldMap old Car Parts
      * @param newMap new Car Parts
      * @author canselagasiyeva
      */
    public static void handleSell(Map<Id, Car_Part__c> oldMap, Map<Id, Car_Part__c> newMap) {
        List<Finance_Transaction__c> newFinanceTransactionList = new List<Finance_Transaction__c>();
        for (Car_Part__c part : newMap.values()) {
            if (part.Is_Sold__c && (oldMap == null || !oldMap.get(part.Id).Is_Sold__c)) {
                newFinanceTransactionList.add(new Finance_Transaction__c(Amount__c = part.Price__c, Car_Part__c = part.Id, Car__c = part.Car__c, Type__c = FinanceTransactionService.SELL_TYPE));
            }
        }
        insert newFinanceTransactionList;
    }

    public static void loadToContainer(List<Car_Part__c> carParts) {
        List<Container__c> containers = new List<Container__c>();
        Set<id> containerIds = new Set<id>();
        for (Car_Part__c cp : carParts) {
            containerIds.add(cp.Container__c);
        }
        Map<id, Container__c> containersMap = new Map<id, Container__c>([Select Capacity__c From Container__c Where id in :containerIds]);

        for (Car_Part__c cp : carParts) {
            if (cp.Container__c != null) {
                if (containersMap.get(cp.Container__c).Capacity__c == null) {
                    Container__c container = new Container__c(id = cp.Container__c, Capacity__c = cp.Weight__c);
                    containers.add(container);
                } else {
                    if (containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c <= 44000) {
                        Container__c container = new Container__c(id = cp.Container__c, Capacity__c = containersMap.get(cp.Container__c).Capacity__c + cp.Weight__c);
                        containers.add(container);
                    } else {
                        cp.addError('Container is full');
                    }
                }
            }
        }
        update containers;
    }

    public static void loadToContainer(List<Car_Part__c> oldCarParts, List<Car_Part__c> newCarParts) {
        List<Car_Part__c> cpWithoutContainer = new List<Car_Part__c>();
        List<Car_Part__c> newCpWithContainer = new List<Car_Part__c>();
        List<Car_Part__c> oldCpWithContainer = new List<Car_Part__c>();

        for (Integer i = 0; i < oldCarParts.size(); i++) {
            if (oldCarParts[i].Container__c == null && newCarParts[i].Container__c != null) {
                cpWithoutContainer.add(newCarParts[i]);
            } else {
                if (oldCarParts[i].Weight__c == null) {
                    cpWithoutContainer.add(newCarParts[i]);
                } else if (oldCarParts[i].Weight__c != newCarParts[i].Weight__c) {
                    oldCpWithContainer.add(oldCarParts[i]);
                    newCpWithContainer.add(newCarParts[i]);
                }
            }
        }

        if (cpWithoutContainer.size() > 0) {
            loadToContainer(cpWithoutContainer);
        }

        if (newCpWithContainer.size() > 0) {
            List<Container__c> containers = new List<Container__c>();
            Set<id> containerIds = new Set<id>();
            for (Car_Part__c cp : newCpWithContainer) {
                containerIds.add(cp.Container__c);
            }

            Map<id, Container__c> containersMap = new Map<id, Container__c>([Select Capacity__c From Container__c Where id in :containerIds]);

            for (Integer i = 0; i < newCpWithContainer.size(); i++) {
                if (newCpWithContainer[i].Container__c != null) {
                    if (containersMap.get(newCpWithContainer[i].Container__c).Capacity__c - oldCpWithContainer[i].Weight__c + newCpWithContainer[i].Weight__c <= 44000) {
                        Container__c container = new Container__c(
                                id = newCpWithContainer[i].Container__c,
                                Capacity__c = containersMap.get(newCpWithContainer[i].Container__c).Capacity__c - oldCpWithContainer[i].Weight__c + newCpWithContainer[i].Weight__c);
                        containers.add(container);
                    } else {
                        newCpWithContainer[i].addError('Container is full');
                    }
                }
            }
            update containers;
        }
    }

    public static void validateContainerField(List<Car_Part__c> carParts) {
        for (Car_Part__c acc : carParts) {
            if (acc.Is_Export__c == true && acc.Container__c == null) {
                acc.Container__c.addError('This parts are not for export');
            } else if (acc.Is_Export__c == false && acc.Container__c != null) {
                acc.Container__c.addError('You can not choose  Container for Local parts');
            }
        }
    }
} 
