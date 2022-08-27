/**
 * @author Dastan
 * @date 2022-08-25
 *
 * @description Test Class for CurrencyConverterIntegration
 */

 @isTest
global class CurrencyConverterIntegrationTest {
    global class CurrencyConverterIntegrationMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {     
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "success": true, "query": { "from": "USD", "to": "EUR", "amount": 100 }, "info": { "timestamp": 1661428084, "rate": 1.000945 }, "date": "2022-08-25", "historical": true, "result": 100.0945 }');
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest 
    static void testCurrencyConverterIntegration() {
        Test.setMock(HttpCalloutMock.class, new CurrencyConverterIntegrationMock()); 
        Double response = CurrencyConverterIntegration.convertAmount('USD', 'EUR', '100', '2022-08-25');
        System.debug(response);
        System.assertEquals(100.0945, response);
    }
}
