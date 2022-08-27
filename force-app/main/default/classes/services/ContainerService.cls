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
        if (containerByCarParts.get(carPart.Container__c) != null) {
          containerByCarParts.get(carPart.Container__c).add(carPart);
        } else {
          containerByCarParts.put(carPart.Container__c, new List<Car_Part__c>{carPart});
        }

        for(Id con : containerByCarParts.keySet()) {
          Integer countOfEngine=0;
          Integer countOfHalfCar=0;
          Integer countOfHood=0;

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

    public static void sendEmailNotification(List<Container__c> containerLists) {
        List<Container__c> containerlist = [
                SELECT Id, Name, (
                        SELECT Name, Container__c, Id, Type__c, Car__c
                        FROM Car_Parts__r
                ), Account__c
                FROM Container__c
        ];

        List<Car_Part__c> hcList = new List<Car_Part__c>();
        List<Car_Part__c> engList = new List<Car_Part__c>();
        for (Container__c container : containerlist) {
            for (Car_Part__c carPart : container.Car_Parts__r) {
                if (carPart.Type__c == 'Half Car') {
                    hcList.add(carPart);
                } else if (carPart.Type__c == 'Engine') {
                    engList.add(carPart);
                }
            }
        }
        if (hcList.size() == 12 && engList.size() == 45) {
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<String> address = new List<String>{
                    'mesmebestwick@gmail.com'
            };

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Container is ready to ship');
            mail.setPlainTextBody('Tracking details for your container');
            mail.setToAddresses(address);
            emailList.add(mail);
            if (!emailList.isEmpty()) {
                Messaging.sendEmail(emailList);
            }
        }
    }
}