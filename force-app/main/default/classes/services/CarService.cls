public with sharing class CarService {
    public static void carTotalCost(list <Car__c> newLists) {
                for(Car__c cob:newLists){
                    cob.Total_Cost__c=cob.Penalty_Cost__c+cob.Storage_Cost__c+cob.Comission__c+cob.Car_Cost__c;
                }
            }
        }
    
    
    
