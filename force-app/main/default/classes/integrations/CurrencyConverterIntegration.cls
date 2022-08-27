/**
 * @author Dastan
 * @date 2022-08-25
 *
 * @description Callout for calculating amount in different currencies
 */
public with sharing class CurrencyConverterIntegration {
    @AuraEnabled(cacheable=true)
    public static Double convertAmount(string sourceCurrency, string targetCurrency, string amount, string dateExc) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        string today = String.valueOf(System.today());
        req.setEndpoint('https://api.apilayer.com/fixer/convert?from='+sourceCurrency+'&to='+targetCurrency+'&amount='+amount+'&date='+dateExc);
        req.setMethod('GET');
        req.setHeader('apikey', Constant.CURRENCY_API_KEY);
        res = http.send(req);
        Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(res.getbody());
        System.debug(responseMap);

        System.debug(responseMap.get('info'));

        return (double) responseMap.get('result');
    }
}
