public with sharing class CarService {
/**
 * Method to calculate auction commission according to price ranges.
 * 
 * @param newList newly inserted, updates properties
 * @author GulnazAtabaeva 
 */

    public static void CommissionCalculator(List<Car__c> newList) {
        for (Car__c car: newList) {
        //Commissions

            //commission up to 1000$
            if (car.Car_Cost__c<=1000) {
                car.Comission__c=170;
            }

            //commission btw 1000$ and 2000$
            else if (car.Car_Cost__c<=2000) {
                car.Comission__c=250;
            }

            //commission btw 2000$ and 5000$
            else if (car.Car_Cost__c<=5000) {
                car.Comission__c=300;
            }

            //comission btw 5000$ and 10000$
            else if (car.Car_Cost__c<=10000) {
                car.Comission__c=350;
            }

            //commission for price more than 10000$
            else {
                car.Comission__c=400;
            }
        }
    }
}
