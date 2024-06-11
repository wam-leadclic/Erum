public with sharing class ButtonWSProductStockController extends AitanaProductStock {

    public Product2 product {get; set;}
    
    public ButtonWSProductStockController(ApexPages.StandardController controller) {
        product = (Product2) controller.getRecord();
    }

    public PageReference updateStock() {
        PageReference pageRef = new PageReference('/' + product.Id);
        pageRef.setRedirect(true);
        try {
            getStock(JSON.serialize(product));
        } catch (CalloutException cEx) {
            return pageRef;
        } catch (DmlException dmlEx) {
            return pageRef;
        }
        return pageRef;
    }

    @future(callout=true)
    public static void getStock(String productJSON) {

        Product2 product_x = (Product2) JSON.deserialize(productJSON, (Product2.class));

        wsSF_Stocks_Port stocksPort = new wsSF_Stocks_Port();
        stocksPort.inputHttpHeaders_x = new Map<String, String>();
        stocksPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        stocksPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        stocksPort.inputHttpHeaders_x.put('SOAPAction', 'GET');
        stocksPort.inputHttpHeaders_x.put('Accept', '*/*');
        stocksPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        stocksPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        stocksPort.outputHttpHeaders_x = new Map<String, String>();
        stocksPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        stocksPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        Read_element readElement = new Read_element();
        readElement.No = product_x.ERUM_External_ProductCode__c;

        wsSF_Stocks stocks = stocksPort.Read(product_x.ERUM_External_ProductCode__c);
        product_x.ERUM_Stock_disponible__c = stocks.StockDisponible;
        Database.update(product_x, true);
    }
}