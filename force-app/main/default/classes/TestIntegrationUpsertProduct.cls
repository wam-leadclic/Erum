@isTest
public class TestIntegrationUpsertProduct extends IntegrationModels {
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

    /**
     * INSERCIÓN DE UN PRODUCTO CON ÉXITO
     */
    @isTest(SeeAllData=false)
    public static void upsertProduct_Test1() {
        RequestBodyProduct productTest = new RequestBodyProduct();
        productTest.foto = 'foto1';
        productTest.no = 'no1';
        productTest.name = 'name1';
        productTest.tipo = 'Inventario';
        productTest.bloqueado = false;
        productTest.unidadMedidaVenta = 'unidadMedidaVenta1';
        productTest.codigoCategoria = 'ALMACEN';
        productTest.codigoGrupoProducto = 'ADZ';
        productTest.grupoProductoServicio = 'GR1';
        productTest.material = 'PP';
        productTest.divisa = 'EUR';
        productTest.volumen = 1.1;
        productTest.medidaPercha = 1.1;
        productTest.anchoPala = 1.1;
        productTest.pesoNeto = 1.1;
        productTest.pesoBruto = 1.1;
        productTest.grupoContable = 'ARANC CV';
        productTest.grupoRegistroIVA = 'EXENTO';
        productTest.grupoContableInventario = 'ENVASES';
        productTest.codigoArancelario = 'codigoArancelario1';
        productTest.tipoPalet = 'Europeo';
        productTest.cantidadPorPalet = 1.1;
        productTest.stockDisponible = 1.1;
        productTest.largoEmbalaje = 1.1;
        productTest.anchoEmbalaje = 1.1;
        productTest.altoEmbalaje = 1.1;
        productTest.pesoEmbalaje = 1.1;
        productTest.volumenEmbalaje = 1.1;
        productTest.unidadEmbalaje = 1.1;
        productTest.tipoMaterial = 'PP';
        productTest.pesoNetoCantidadEmbalada = 1.1;
        productTest.pesoBrutoCantidadEmbalada = 1.1;
        productTest.tipoMateriaPrima = 'No procede';
        productTest.nivelTecnologico = 'No procede';
        productTest.tipoProducto = 'tipoProducto1';
        productTest.descripcionProducto = 'descripcionProducto1';
        productTest.enviadaERP = false;
        productTest.fechaEnvioERP = System.today();
        IntegrationUpsertProduct.upsertProduct(productTest);
    }

    /**
     * EDICIÓN DE UN PRODUCTO CON ÉXITO
     */
    @isTest(SeeAllData=false)
    public static void upsertProduct_Test2() {
        RequestBodyProduct productTest = new RequestBodyProduct();
        productTest.foto = 'foto';
        productTest.no = 'no';
        productTest.name = 'name';
        productTest.tipo = 'Inventario';
        productTest.bloqueado = false;
        productTest.unidadMedidaVenta = 'unidadMedidaVenta';
        productTest.codigoCategoria = 'ALMACEN';
        productTest.codigoGrupoProducto = 'ADZ';
        productTest.grupoProductoServicio = 'GR1';
        productTest.material = 'PP';
        productTest.divisa = 'EUR';
        productTest.volumen = 2.0;
        productTest.medidaPercha = 2.0;
        productTest.anchoPala = 2.0;
        productTest.pesoNeto = 2.0;
        productTest.pesoBruto = 2.0;
        productTest.grupoContable = 'ARANC CV';
        productTest.grupoRegistroIVA = 'EXENTO';
        productTest.grupoContableInventario = 'ENVASES';
        productTest.codigoArancelario = 'codigoArancelario';
        productTest.tipoPalet = 'Europeo';
        productTest.cantidadPorPalet = 2.0;
        productTest.stockDisponible = 2.0;
        productTest.largoEmbalaje = 2.0;
        productTest.anchoEmbalaje = 2.0;
        productTest.altoEmbalaje = 2.0;
        productTest.pesoEmbalaje = 2.0;
        productTest.volumenEmbalaje = 2.0;
        productTest.unidadEmbalaje = 2.0;
        productTest.tipoMaterial = 'PP';
        productTest.pesoNetoCantidadEmbalada = 2.0;
        productTest.pesoBrutoCantidadEmbalada = 2.0;
        productTest.tipoMateriaPrima = 'No procede';
        productTest.nivelTecnologico = 'No procede';
        productTest.tipoProducto = 'tipoProducto';
        productTest.descripcionProducto = 'descripcionProducto';
        productTest.enviadaERP = false;
        productTest.fechaEnvioERP = System.today();
        IntegrationUpsertProduct.upsertProduct(productTest);
    }

    /**
     * ERROR AL INSERTAR UN PRODUCTO
     */
    @isTest(SeeAllData=false)
    public static void upsertProduct_Test3() {
        RequestBodyProduct productTest = new RequestBodyProduct();
        productTest.foto = 'foto3';
        productTest.no = 'no3';
        productTest.name = 'name3';
        productTest.tipo = 'Inventario';
        productTest.bloqueado = false;
        productTest.unidadMedidaVenta = 'unidadMedidaVenta3';
        productTest.codigoCategoria = 'ALMACEN';
        productTest.codigoGrupoProducto = 'ADZ';
        productTest.grupoProductoServicio = 'GR3'; // ¡ESTE CAMPO VA A LANZAR UNA EXCEPCIÓN!
        productTest.material = 'PP';
        productTest.divisa = 'EUR';
        productTest.volumen = 3.3;
        productTest.medidaPercha = 3.3;
        productTest.anchoPala = 3.3;
        productTest.pesoNeto = 3.3;
        productTest.pesoBruto = 3.3;
        productTest.grupoContable = 'ARANC CV';
        productTest.grupoRegistroIVA = 'EXENTO';
        productTest.grupoContableInventario = 'ENVASES';
        productTest.codigoArancelario = 'codigoArancelario3';
        productTest.tipoPalet = 'Europeo';
        productTest.cantidadPorPalet = 3.3;
        productTest.stockDisponible = 3.3;
        productTest.largoEmbalaje = 3.3;
        productTest.anchoEmbalaje = 3.3;
        productTest.altoEmbalaje = 3.3;
        productTest.pesoEmbalaje = 3.3;
        productTest.volumenEmbalaje = 3.3;
        productTest.unidadEmbalaje = 3.3;
        productTest.tipoMaterial = 'PP';
        productTest.pesoNetoCantidadEmbalada = 3.3;
        productTest.pesoBrutoCantidadEmbalada = 3.3;
        productTest.tipoMateriaPrima = 'No procede';
        productTest.nivelTecnologico = 'No procede';
        productTest.tipoProducto = 'tipoProducto3';
        productTest.descripcionProducto = 'descripcionProducto3';
        productTest.enviadaERP = false;
        productTest.fechaEnvioERP = System.today();
        IntegrationUpsertProduct.upsertProduct(productTest);
    }

    /**
     * ERROR AL EDITAR UN PRODUCTO
     */
    @isTest(SeeAllData=false)
    public static void upsertProduct_Test4() {
        RequestBodyProduct productTest = new RequestBodyProduct();
        productTest.foto = 'foto';
        productTest.no = 'no';
        productTest.name = 'name';
        productTest.tipo = 'Inventario';
        productTest.bloqueado = false;
        productTest.unidadMedidaVenta = 'unidadMedidaVenta';
        productTest.codigoCategoria = 'ALMACEN';
        productTest.codigoGrupoProducto = 'ADZ';
        productTest.grupoProductoServicio = 'GR4';
        productTest.material = 'PP';
        productTest.divisa = 'EUR';
        productTest.volumen = 4.0;
        productTest.medidaPercha = 4.0;
        productTest.anchoPala = 4.0;
        productTest.pesoNeto = 4.0;
        productTest.pesoBruto = 4.0;
        productTest.grupoContable = 'ARANC CV';
        productTest.grupoRegistroIVA = 'EXENTO';
        productTest.grupoContableInventario = 'ENVASES';
        productTest.codigoArancelario = 'codigoArancelario';
        productTest.tipoPalet = 'Europeo';
        productTest.cantidadPorPalet = 4.0;
        productTest.stockDisponible = 4.0;
        productTest.largoEmbalaje = 4.0;
        productTest.anchoEmbalaje = 4.0;
        productTest.altoEmbalaje = 4.0;
        productTest.pesoEmbalaje = 4.0;
        productTest.volumenEmbalaje = 4.0;
        productTest.unidadEmbalaje = 4.0;
        productTest.tipoMaterial = 'PP';
        productTest.pesoNetoCantidadEmbalada = 4.0;
        productTest.pesoBrutoCantidadEmbalada = 4.0;
        productTest.tipoMateriaPrima = 'No procede';
        productTest.nivelTecnologico = 'No procede';
        productTest.tipoProducto = 'tipoProducto';
        productTest.descripcionProducto = 'descripcionProducto';
        productTest.enviadaERP = false;
        productTest.fechaEnvioERP = System.today();
        IntegrationUpsertProduct.upsertProduct(productTest);
    }

    /**
     * ERROR INTERNO DEL SERVIDOR
     */
    @isTest(SeeAllData=false)
    public static void upsertProduct_Test5() {
        IntegrationUpsertProduct.upsertProduct(null);
    }
}