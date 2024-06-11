global virtual with sharing class IntegrationModels {
    
    global class SuccessResponse extends Response{
        webservice String message;
        webservice String code;
    }

    global class ErrorResponse extends Response{
        webservice String message;
        webservice String errorType;
    }
    
    global abstract class Response{
        
    }

    global class RequestBodyProduct {
        webservice String foto;
        webservice String no;
        webservice String nombre;
        webservice String name;
        webservice String tipo;
        webservice Boolean bloqueado;
        webservice String unidadMedidaVenta;
        webservice String codigoCategoria;
        webservice String codigoGrupoProducto;
        webservice String grupoProductoServicio;
        webservice String material;
        webservice String divisa;
        webservice Decimal volumen;
        webservice Decimal medidaPercha;
        webservice Decimal anchoPala;
        webservice Decimal pesoNeto;
        webservice Decimal pesoBruto;
        webservice String grupoContable;
        webservice String grupoRegistroIVA;
        webservice String grupoContableInventario;
        webservice String codigoArancelario;
        webservice String tipoPalet;
        webservice Decimal cantidadPorPalet;
        webservice Decimal stockDisponible;
        webservice Decimal largoEmbalaje;
        webservice Decimal anchoEmbalaje;
        webservice Decimal altoEmbalaje;
        webservice Decimal pesoEmbalaje;
        webservice Decimal volumenEmbalaje;
        webservice Decimal unidadEmbalaje;
        webservice String tipoMaterial;
        webservice Decimal pesoNetoCantidadEmbalada;
        webservice Decimal pesoBrutoCantidadEmbalada;
        webservice String tipoMateriaPrima;
        webservice String nivelTecnologico;
        webservice String tipoProducto;
        webservice String descripcionProducto;
        webservice Boolean enviadaERP;
        webservice Date fechaEnvioERP;
    }

    global class RequestBodyTarifa {
        webservice String nombre;
        webservice String descripcion;
        webservice Decimal moneda;
        webservice Date fechaInicio;
        webservice Date fechaFin;
        webservice String externalId;
        webservice Boolean activa;
        webservice List<RequestBodyLineaTarifa> entradas;
    }

    global class RequestBodyLineaTarifa {
        webservice Integer idLineaTarifa;
        webservice String tipoVenta;
        webservice String codVentas;
        webservice String nombreCodVentas;
        webservice String codUdMedida;
        webservice Decimal precioVenta;
        webservice Date fechaInicial;
        webservice Date fechaFinal;
        webservice Boolean incluirCosteContenedor;
        webservice String divisa;
        webservice String productNo;
    }

}