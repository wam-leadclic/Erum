@isTest
public class TestIntegrationUpsertTarifa extends IntegrationModels {
    
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

        Product2 productTestSinTarifa = new Product2(
            IsActive = true,
            DisplayUrl = 'foto1',
            ERUM_External_ProductCode__c = 'no1',
            Name = 'name1',
            ERUM_Tipo__c = 'Inventario',
            ERUM_Bloqueado__c = false,
            QuantityUnitOfMeasure = 'unidadMedidaVenta1',
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
            ProductCode = 'codigoArancelario1',
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
            Family = 'tipoProducto1',
            Description = 'descripcionProducto1',
            ERUM_Enviada_ERP__c = false,
            Fecha_envio_ERP__c = System.today()
        );
        insert productTestSinTarifa;

        Pricebook2 tarifaTest = new Pricebook2(
            Name = 'nombre',
            Description = 'descripcion',
            IsActive = true,
            ERUM_Moneda__c = 1.0,
            ERUM_Fecha_Inicio__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_PB_Id_External__c = 'externalId'
        );
        insert tarifaTest;

        PricebookEntry standardEntryTest = new PricebookEntry(
            ERUM_Tipo_de_venta__c = 'Cliente',
            ERUM_Codigo_de_ventas__c = 'cvStandard',
            ERUM_Nombre_codigo_de_ventas__c = 'nombreCVS',
            C_d_Unidad_de_medida__c = 'CAJA',
            UnitPrice = 1.0,
            ERUM_Fecha_Inicial__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_Incluir_coste_contenedor__c = false,
            CurrencyIsoCode = 'EUR',
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productTest.Id,
            Id_LineaTarifa__c = null
        );
        insert standardEntryTest;

        PricebookEntry entryTest = new PricebookEntry(
            ERUM_Tipo_de_venta__c = 'Cliente',
            ERUM_Codigo_de_ventas__c = 'codVentas',
            ERUM_Nombre_codigo_de_ventas__c = 'nombreCV',
            C_d_Unidad_de_medida__c = 'CAJA',
            UnitPrice = 2.0,
            ERUM_Fecha_Inicial__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_Incluir_coste_contenedor__c = false,
            CurrencyIsoCode = 'EUR',
            Pricebook2Id = tarifaTest.Id,
            Product2Id = productTest.Id,
            Id_LineaTarifa__c = 0
        );
        insert entryTest;

        Pricebook2 tarifaTestSinLineas = new Pricebook2(
            Name = 'nombreSinLineas',
            Description = 'descripcioSinLineas',
            IsActive = true,
            ERUM_Moneda__c = 100.0,
            ERUM_Fecha_Inicio__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_PB_Id_External__c = 'externalIdSinLineas'
        );
        insert tarifaTestSinLineas;
    }

    /**
     * INSERCIÓN DE UNA TARIFA Y SUS LÍNEAS CON ÉXITO
     */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test1() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre1';
        tarifaTest.descripcion = 'descripcion1';
        tarifaTest.moneda = 1.1;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId1';

        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas1';
        lineaTarifaTest.nombreCodVentas = 'nombreCV1';
        lineaTarifaTest.codUdMedida = 'CAJA';
        lineaTarifaTest.precioVenta = 1.1;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no';
        lineaTarifaTest.idLineaTarifa = 1;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * INSERCIÓN DE UNA TARIFA SIN LÍNEAS CON ÉXITO
     */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test2() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre2';
        tarifaTest.descripcion = 'descripcion2';
        tarifaTest.moneda = 2.2;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId2';

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * INSERCIÓN DE UNA NUEVA LÍNEA EN UNA TARIFA EXISTENTE CON LÍNEAS CON ÉXITO
     */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test3() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre';
        tarifaTest.descripcion = 'descripcion';
        tarifaTest.moneda = 3.3;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId';

        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas3';
        lineaTarifaTest.nombreCodVentas = 'nombreCV3';
        lineaTarifaTest.codUdMedida = 'CAJA';
        lineaTarifaTest.precioVenta = 3.3;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no1';
        lineaTarifaTest.idLineaTarifa = 3;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * INSERCIÓN DE UNA NUEVA LÍNEA EN UNA TARIFA EXISTENTE SIN LÍNEAS CON ÉXITO
     */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test4() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombreSinLineas';
        tarifaTest.descripcion = 'descripcionSinLineas';
        tarifaTest.moneda = 4.4;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalIdSinLineas';

        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas4';
        lineaTarifaTest.nombreCodVentas = 'nombreCV4';
        lineaTarifaTest.codUdMedida = 'CAJA';
        lineaTarifaTest.precioVenta = 4.4;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no1';
        lineaTarifaTest.idLineaTarifa = 4;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * ERROR AL INSERTAR/EDITAR TARIFA SIN LÍNEAS
     */
    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test5() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre5';
        tarifaTest.descripcion = 'descripcion5';
        tarifaTest.moneda = 12345678910.12;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId5';

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * ERROR AL ENCONTRAR PRODUCTO DE LÍNEA DE TARIFA
     */
    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test6() {
        
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre6';
        tarifaTest.descripcion = 'descripcion6';
        tarifaTest.moneda = 6.6;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId6';

        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas6';
        lineaTarifaTest.nombreCodVentas = 'nombreCV6';
        lineaTarifaTest.codUdMedida = 'CAJA';
        lineaTarifaTest.precioVenta = 6.6;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no_6_inexistente';
        lineaTarifaTest.idLineaTarifa = 6;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;

        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    
    /**
     * ERROR AL INSERTAR LÍNEAS
     */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test7() {
         
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre';
        tarifaTest.descripcion = 'descripcion';
        tarifaTest.moneda = 7.7;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId';
 
        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas7';
        lineaTarifaTest.nombreCodVentas = 'nombreCV7';
        lineaTarifaTest.codUdMedida = 'FGASGASGA';
        lineaTarifaTest.precioVenta = 7.7;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no1';
        lineaTarifaTest.idLineaTarifa = 7;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;
 
        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
    * ERROR AL EDITAR LÍNEAS
    */

    @isTest(SeeAllData=false)
    public static void upsertTarifa_Test8() {
         
        RequestBodyTarifa tarifaTest = new RequestBodyTarifa();
        tarifaTest.activa = true;
        tarifaTest.nombre = 'nombre';
        tarifaTest.descripcion = 'descripcion';
        tarifaTest.moneda = 8.8;
        tarifaTest.fechaInicio = System.today();
        tarifaTest.fechaFin = System.today();
        tarifaTest.externalId = 'externalId';
 
        RequestBodyLineaTarifa lineaTarifaTest = new RequestBodyLineaTarifa();
        lineaTarifaTest.tipoVenta = 'Cliente';
        lineaTarifaTest.codVentas = 'codVentas8';
        lineaTarifaTest.nombreCodVentas = 'nombreCV8';
        lineaTarifaTest.codUdMedida = 'WASDDGDSFH';
        lineaTarifaTest.precioVenta = 8.8;
        lineaTarifaTest.fechaInicial = System.today();
        lineaTarifaTest.fechaFinal = System.today();
        lineaTarifaTest.incluirCosteContenedor = false;
        lineaTarifaTest.divisa = 'EUR';
        lineaTarifaTest.productNo = 'no';
        lineaTarifaTest.idLineaTarifa = 8;
        
        List<RequestBodyLineaTarifa> lineas = new List<RequestBodyLineaTarifa>();
        lineas.add(lineaTarifaTest);
        tarifaTest.entradas = lineas;
 
        IntegrationUpsertTarifa.upsertTarifa(tarifaTest);
    }

    /**
     * ERROR INTERNO DEL SERVIDOR
     */

     @isTest(SeeAllData=false)
     public static void upsertTarifa_Test9() {
        IntegrationUpsertTarifa.upsertTarifa(null);
    }
}