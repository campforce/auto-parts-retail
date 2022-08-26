@RestResource(urlMapping='/CarParts')
global class CarPartsIntegration {
    
    @HttpGet
    global static void getAvailableCarParts() {
        List<CarPartStructure> carParts = new List<CarPartStructure>();

        for(Car_Part__c carPart : [SELECT Id, Name, Car__r.Name, Price__c, Weight__c FROM Car_Part__c WHERE Is_Sold__c = FALSE]) {
            carParts.add(new CarPartStructure(carPart.Id, carPart.Name, carPart.Car__r.Name, carPart.Price__c, carPart.Weight__c));
        }

        RestResponse response = RestContext.response;
        
        response.statusCode = 200;
        response.responseBody = Blob.valueOf(JSON.serializePretty(carParts));
    }

    public class CarPartStructure {
        private String id;
        private String name;
        private String carName;
        private Decimal price;
        private Decimal weight;

        public CarPartStructure(String id, String name, String carName, Decimal price, Decimal weight) {
            this.id = id;
            this.name = name;
            this.carName = carName;
            this.price = price;
            this.weight = weight;
        }
    }
}