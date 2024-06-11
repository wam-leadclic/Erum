@isTest
public class TestProductStock {
    
    public class StockMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {

            AitanaProductStock.wsSF_Stocks producto = new AitanaProductStock.wsSF_Stocks();
            producto.Key = 'test';
            producto.No = 'no';
            producto.Inventory = 100;
            producto.StockDisponible = 50;
            if (requestName == 'Read') {
                AitanaProductStock.Read_Result_element readResult = new AitanaProductStock.Read_Result_element();
                readResult.wsSF_Stocks = producto;
                response.put('response_x', readResult);
            }
        }
    }

    @TestSetup
    static void makeData(){
        TrgController.setDoNotRunTrigger();
        Product2 productTest = new Product2(
            IsActive = true,
            DisplayUrl = 'foto',
            ERUM_External_ProductCode__c = 'no',
            Name = 'name',
            ERUM_Tipo__c = 'Inventario',
            ERUM_Bloqueado__c = false,
            QuantityUnitOfMeasure = 'unidadMedidaVenta',
            ERUM_Cod_categoria_producto__c = 'ALMACEN',
            ERUM_Cod_grupo_producto__c = 'ADZ',
            ERUM_Grupo_prod_Servicio__c = 'GR1',
            ERUM_Material_producto__c = 'PP',
            CurrencyIsoCode = 'EUR',
            ERUM_Volumen__c = 1.0,
            ERUM_Media_percha__c = 1.0,
            ERUM_Ancho_pala__c = 1.0,
            ERUM_Peso_neto__c = 1.0,
            ERUM_Peso_bruto__c = 1.0,
            ERUM_Grupo_contable_producto__c = 'ARANC CV',
            ERUM_Grupo_registro_IVA_prod__c = 'EXENTO',
            ERUM_Grupo_contable_inventario__c = 'ENVASES',
            ProductCode = 'codigoArancelario',
            ERUM_Tipo_palet__c = 'Europeo',
            ERUM_Cantidad_por_palet__c = 1.0,
            ERUM_Stock_disponible__c = 1.0,
            ERUM_Largo_embalaje__c = 1.0,
            ERUM_Ancho_embalaje__c = 1.0,
            ERUM_Alto_embalaje__c = 1.0,
            ERUM_Peso_embalaje__c = 1.0,
            ERUM_Volumen_embalaje__c = 1.0,
            ERUM_Unidad_embalaje__c = 1.0,
            ERUM_Tipo_de_material__c = 'PP',
            ERUM_Peso_neto_cantidad_embalada__c = 1.0,
            ERUM_Peso_bruto_cantidad_embalada__c = 1.0,
            ERUM_Tipo_de_materia_prima__c = 'No procede',
            ERUM_Nivel_tecnoligico__c = 'No procede',
            Family = 'tipoProducto',
            Description = 'descripcionProducto',
            ERUM_Enviada_ERP__c = false,
            Fecha_envio_ERP__c = System.today()
        );
        insert productTest;
    }

    @isTest
    public static void testProductStock_1() {
        Product2 test1 = [SELECT Id, ERUM_External_ProductCode__c FROM Product2 WHERE ERUM_External_ProductCode__c =: 'no' LIMIT 1];
        Pagereference pRef = Page.ButtonWSProductStockPage;
        Test.setMock(WebServiceMock.class, new StockMock());
        Test.setCurrentPage(pRef);
        Test.startTest();
        ApexPages.StandardController sCtrl = new ApexPages.StandardController(test1);
        ButtonWSProductStockController ctrl = new ButtonWSProductStockController(sCtrl);
        ctrl.updateStock();
        Test.stopTest();
    }
}