public class GeolocationQueueable implements Queueable, Database.AllowsCallouts {
    Map<Id, String> addressByAccountIds;
    
    /*
     * Class updates accounts geolocation depending on address.
     * Sends API callout to external system.
     * 
     * @param accountList - List of Account for updating address
     * @author belekomurzakov, martincapek
     */
    public GeolocationQueueable(List<Account> accountList) {
        this.addressByAccountIds = new Map<Id, String>();
        for(Account acc : accountList) {
            if(acc.BillingStreet != null && acc.BillingCity != null && acc.BillingCountry != null ) {
                addressByAccountIds.put(acc.Id, acc.BillingStreet.replaceAll(' ', '') + '+' + acc.BillingCity.replaceAll(' ', '') + '+' + acc.BillingCountry.replaceAll(' ', ''));
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
    
    public static GeolocationStructure getGeolocation(String address) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=' + Constant.GOOGLE_API_KEY;
        request.setEndPoint(endpoint);
        request.setMethod('GET');    
        HttpResponse response = httpProtocol.send(request);
        return GeolocationStructure.parse(response.getBody());
    }
}