public with sharing class ContainerService {

/**
     * Method to make sure the required minimum for engine, half car and hood amounts to be sent to release.
     *
     * @param newMap new Containers
     * @param oldMap old Containers
     * 
     * @author GulnazAtabaeva
     */

    public static void minimumRequirements(Map<Id, Container__c> newMap, Map<Id, Container__c> oldMap) {
      Set<Id> containerIds = new Set<Id>();
      for (Container__c cont : newMap.values()){
          if(oldMap.get(cont.Id).Status__c=='Loading' && cont.Status__c=='Release') {
          containerIds.add(cont.Id);
      }
}
      Map<Id, List<Car_Part__c>> containerByCarParts = new Map<Id, List<Car_Part__c>>();

  	for(Car_Part__c carPart : [SELECT Id, Type__c, Container__c FROM Car_Part__c WHERE Container__c IN :containerIds]) {
       if(containerByCarParts.get(carPart.Container__c) != null) {
        containerByCarParts.get(carPart.Container__c).add(carPart);
 } 		
          else {
        containerByCarParts.put(carPart.Container__c, new List<Car_Part__c>{carPart});
 }
          
      for(Id con : containerByCarParts.keySet()) {
          Integer countOfEngine;
          Integer countOfHalfCar;
          Integer countOfHood;
          
      for(Car_Part__c cp : containerByCarParts.get(con)) {
          if(cp.Type__c=='Engine') {
                  countOfEngine+=1;
              }
          if(carpart.Type__c=='Half Car') {
                  countOfHalfCar+=1;
              }
          if(carpart.Type__c=='Hood') {
                  countOfHood+=1;
              }    
      }
          if(countOfEngine<40 || countOfHalfCar<12 || countOfHood<5) {
              newMap.get(con).addError('You cannot change status until all requirements are met.');
        }
      }
    }
  }
}
