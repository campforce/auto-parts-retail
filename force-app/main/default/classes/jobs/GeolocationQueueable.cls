    /*
     * Method to get geolocation from account address 
     * 
     * @author belekomurzakov, martincapek
    */
Public with sharing class GeolocationQueueable implements Queueable, Database.AllowsCallouts {
    //googlemaps private API key, get your own
    private final static String key = 'AIzaSyBYBP5ajTnpCgSGqf399Pd7wXsQR26V45c';
    Map<Id, String> addressByAccountIds;
    public GeolocationQueueable(List<Account> accountList) {
        this.addressByAccountIds = new Map<Id, String>();
        for(Account acc : accountList) {
            if(acc.BillingStreet != null && acc.BillingCity != null && acc.BillingCountry != null ) {
                addressByAccountIds.put(acc.Id, acc.BillingStreet.replaceAll(' ', '')
                + '+' + acc.BillingCity.replaceAll(' ', '') + '+' + acc.BillingCountry.replaceAll(' ', ''));
            }
        }
    }
    public void execute(QueueableContext context) {
        List<Account> accountsToUpdate = new List<Account>();
        for(Account account : [SELECT Id, Geolocation__Latitude__s, Geolocation__Longitude__s FROM Account WHERE Id IN :addressByAccountIds.keySet()]) {        
            GeolocationStructure geo = getGeolocation(addressByAccountIds.get(account.Id));            
            account.Geolocation__Latitude__s = geo.results[0].geometry.location.lat;
            account.Geolocation__Longitude__s = geo.results[0].geometry.location.lng; 
            accountsToUpdate.add(account);                        
        }
        
        update accountsToUpdate;
    }
    //API callout
    public static GeolocationStructure getGeolocation(String address) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;
        request.setEndPoint(endpoint);
        request.setMethod('GET');    
        HttpResponse response = httpProtocol.send(request);
        return GeolocationStructure.parse(response.getBody());
    }
}