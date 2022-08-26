public with sharing class CarService {
    
     /**  method to calculate transportation cost  
     *
     * @param oldMap car__c
     * @param newList car__c
     * @author AssemTleuova
     */
    public static void calculateTransportation(Map<Id, Car__c> oldMap, List<Car__c> newList) {
        for(Car__c car : newList) {
            Decimal fee = car.Transportation__c;
            if(fee == null) {
                fee = 0;
            }
            if(oldMap != null) {
                if(oldMap.get(car.Id).Weight__c != car.Weight__c) {
                    if(oldMap.get(car.Id).Weight__c > 0 && oldMap.get(car.Id).Weight__c != null) {
                        fee -= handleWeight(oldMap.get(car.Id).Weight__c);
                    }
                    if(car.Weight__c > 0 && car.Weight__c != null) {
                        fee += handleWeight(car.Weight__c);  
                    }                      
                }
                if(oldMap.get(car.Id).Distance__c != car.Distance__c) {
                    if(oldMap.get(car.Id).Distance__c > 0 && oldMap.get(car.Id).Distance__c != null) {
                        fee -= handleDistance(oldMap.get(car.Id).Distance__c);
                    }
                    if(car.Distance__c > 0 && car.Distance__c != null) {
                        fee += handleDistance(car.Distance__c);
                    }
                }
            } else {
                if(car.Weight__c != null) {
                    fee += handleWeight(car.Weight__c);
                }
                if (car.Distance__c  != null) {
                    fee += handleDistance(car.Distance__c);
                }
            }
            car.Transportation__c = fee;
        }      
    }
    private static Decimal handleWeight(Decimal weight) {
        if (weight > 3000 && Math.round((weight - 3000) / 1000) > 0) {
            return (Math.round((weight - 3000) / 1000) * 25) + 75;
        }
        return 75;
    }
    private static Decimal handleDistance(Decimal distance) {
        if (distance > 80 && Math.round((distance - 80) / 45) > 0) {
            return (Math.round((distance - 80) / 45) * 25) + 75;
        }
        return 75;
    }



     /* Method to calculate total cost.
     *
     * @param newList newly inserted, updates cars
     * @author aysel
     */
    public static void carTotalCost(list <Car__c> newLists) {
      for(Car__c cob:newLists){
        if(cob.Total_Cost__c != null) {        
            if(cob.Penalty_Cost__c != null) {
                cob.Total_Cost__c += cob.Penalty_Cost__c;
            }
            if(cob.Storage_Cost__c != null) {
                cob.Total_Cost__c += cob.Storage_Cost__c;
            }
            if(cob.Comission__c != null) {
                cob.Total_Cost__c += cob.Comission__c;
            }
            if(cob.Car_Cost__c != null) {
                cob.Total_Cost__c += cob.Car_Cost__c;
            }
        }
      }
    }    

    /**
     * Method to calculate auction commissions according to price ranges.
     *
     * @param newList newly inserted, updates properties
     * @author GulnazAtabaeva
     */
    public static void commissionCalculator(List<Car__c> newList) {
        for (Car__c car : newList) {
            if (car.Car_Cost__c <= 1000) { //commission up to 1000$
                car.Comission__c = 170;
            } else if (car.Car_Cost__c <= 2000) { //commission btw 1000$ and 2000$
                car.Comission__c = 250;
            } else if (car.Car_Cost__c <= 5000) { //commission btw 2000$ and 5000$
                car.Comission__c = 300;
            } else if (car.Car_Cost__c <= 10000) { //comission btw 5000$ and 10000$
                car.Comission__c = 350;
            } else { //commission for price more than 10000$
                car.Comission__c = 400;
            }
        }
    }
}
