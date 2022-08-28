public with sharing class CarService {

    /**
     * Approval process for the parts to be pulled if the status of the Car object is 'in the yard'.
     *
     * @param oldMap old car__c
     * @param newMap new car__c
     * @author gulzatbaimyrzaeva
     */
    public static void approvalProcess(List <Car__c> newCarList, Map<Id, Car__c> oldMap) {
        for (Car__c car : newCarList) {
            if (car.Status__c == 'In The Yard' && oldMap.get(car.Id).Status__c != 'In the Yard') {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Approving request for approvals  using Trigger');
                req.setObjectId(car.Id);
                req.setNextApproverIds(new Id[]{
                        UserInfo.getUserId()
                });
                //submit the approval request for the  Car object 
                Approval.ProcessResult result = Approval.Process(req);
            }
        }
    }

    /**
     * Method to calculate total cost.
     *
     * @param newList newly inserted, updates cars
     * @author aysel
     */
    public static void carTotalCost(list <Car__c> newLists) {
        for (Car__c cob : newLists) {
            if (cob.Total_Cost__c != null) {
                if (cob.Penalty_Cost__c != null) {
                    cob.Total_Cost__c += cob.Penalty_Cost__c;
                }
                if (cob.Storage_Cost__c != null) {
                    cob.Total_Cost__c += cob.Storage_Cost__c;
                }
                if (cob.Comission__c != null) {
                    cob.Total_Cost__c += cob.Comission__c;
                }
                if (cob.Car_Cost__c != null) {
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
    public static void commissionCalculator(List <Car__c> newList) {
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

    /**
     *
     * @param newMap new
     * @param oldMap old 
     * @author Oleh
     */
    public static void feeSumEmailToCEO(Map<Id, Car__c> newMap, Map<Id, Car__c> oldMap) {
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
        };
        for (Car__c car : newMap.values()) {
            if (car.Storage_Cost__c == oldMap.get(car.Id).Storage_Cost__c && car.Penalty_Cost__c == oldMap.get(car.Id).Penalty_Cost__c
                    || (car.Storage_Cost__c == null || car.Penalty_Cost__c == null)) {
                continue;
            }

            if ((car.Storage_Cost__c + car.Penalty_Cost__c) <= 1000) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[]{'oleh.chkh@gmail.com'};
                message.setSubject('Too many fees here, boss');
                message.plainTextBody = 'Hey,' + car.name + 'has too many fees. Penaly charges exceed $1k. Cut $400 from the superwisors wage!';
                messages.add(message);
            }
        }
        Messaging.sendEmail(messages);
    }

    /**
     * Method to calculate distance between car auction location and company yard
     * @param newList newly inserted, updated cars
     * @author MartinCapek
     */
    public static void distanceCalc(List<Car__c> newList) {
        final Location yard = Location.newInstance(40.453151587554444, -76.43538154417556);
        Map <Id, Car__c> carsByAccountIds = new Map <Id, Car__c>();
        for (Car__c car : newList) {
            carsByAccountIds.put(car.Account__c, car);
        }
        for (Account relAccount : [SELECT Id, Geolocation__c FROM Account WHERE Id In :CarsByAccountIds.keySet() AND Geolocation__Latitude__s != NULL AND Geolocation__Longitude__s != NULL]) {
            carsByAccountIds.get(relAccount.Id).Distance__c = Location.getDistance(relAccount.Geolocation__c, yard, 'mi');
        }
    }

    public static void valdiateCurrencyField(Map<Id, Car__c> newMap, Map<Id, Car__c> oldMap) {
        for (Car__c c : newMap.values()) {
            if ((oldMap.get(c.Id).Status__c != 'Done' && c.Status__c == 'Done') && c.Currency__c == null) {
                c.Currency__c.addError('Please select currency');
            }
        }
    }

    /**
     * Method to add extra $100 for transportation if the is not drivable.
     *
     * @param oldMap car__c
     * @param newList car__c
     * @author RomanDanylchenko
     */
    public static void handleDrivable(Map<Id, Car__c> oldMap, List<Car__c> newList) {
        for (Car__c car : newList) {
            Decimal amount = car.Transportation__c;
            if (car.Transportation__c == null) {
                amount = 0;
            }
            if (oldMap == null || oldMap.get(car.Id).Is_Drivable__c != car.Is_Drivable__c) {
                if (!car.Is_Drivable__c) {
                    amount += 100;
                } else if (car.Is_Drivable__c && oldMap != null) {
                    amount -= 100;
                }
            }
            car.Transportation__c = amount;
        }
    }

    /**    method to calculate transportation cost
     *
     * @param oldMap car__c
     * @param newList car__c
     * @author AssemTleuova
     */
    public static void calculateTransportation(Map<Id, Car__c> oldMap, List<Car__c> newList) {
        for (Car__c car : newList) {
            Decimal fee = car.Transportation__c;
            if (fee == null) {
                fee = 0;
            }
            if (oldMap != null) {
                if (oldMap.get(car.Id).Weight__c != car.Weight__c) {
                    if (oldMap.get(car.Id).Weight__c > 0 && oldMap.get(car.Id).Weight__c != null) {
                        fee -= handleWeight(oldMap.get(car.Id).Weight__c);
                    }
                    if (car.Weight__c > 0 && car.Weight__c != null) {
                        fee += handleWeight(car.Weight__c);
                    }
                }
                if (oldMap.get(car.Id).Distance__c != car.Distance__c) {
                    if (oldMap.get(car.Id).Distance__c > 0 && oldMap.get(car.Id).Distance__c != null) {
                        fee -= handleDistance(oldMap.get(car.Id).Distance__c);
                    }
                    if (car.Distance__c > 0 && car.Distance__c != null) {
                        fee += handleDistance(car.Distance__c);
                    }
                }
            } else {
                if (car.Weight__c != null) {
                    fee += handleWeight(car.Weight__c);
                }
                if (car.Distance__c != null) {
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
}
