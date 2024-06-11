public class GestionRiesgosController {
    
    public Account potencial;
    public String cif {get;set;}
    public String numeroExp {get;set;}
    public Date fechaExp {get;set;}
    public Decimal diasAsegurado {get;set;}
    public String limiteCredito {get;set;}
    public String clasificacion {get;set;}
    public String errorDetail {get;set;}
    public Boolean errorIsNotNull {get; set;}
    public String successDetail {get;set;}
    public Boolean successIsNotNull {get; set;}
    public List<SelectOption> clasificacionList {
        get {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Account.Clasificacion__c.getDescribe();
            List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry entry : entries) {
                options.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return options;
        }
    }

    public GestionRiesgosController() {
        errorIsNotNull = false;
        successIsNotNull = false;
        cif = ApexPages.currentpage().getparameters().get('cif');
    }

    public void updateClientePotencial() {
        potencial = [
            SELECT Id, ERUM_CIF_Europeo__c, Num_Exp_CYC__c, Fecha_Exp_CYC__c, Dias_Asegurado_CYC__c, Limite_Credito_CYC__c, Clasificacion__c, ERUM_Estado__c
            FROM Account 
            WHERE ERUM_CIF_Europeo__c =: cif
            AND RecordType.Name = 'Cliente Potencial'
            LIMIT 1
        ];
        System.debug(potencial.ERUM_CIF_Europeo__c);
        potencial.Num_Exp_CYC__c = numeroExp;
        potencial.Fecha_Exp_CYC__c = fechaExp;
        potencial.Dias_Asegurado_CYC__c = diasAsegurado;
        potencial.Limite_Credito_CYC__c = Decimal.valueOf(limiteCredito);
        potencial.Clasificacion__c = clasificacion;
        potencial.ERUM_Estado__c = 'Fin de Análisis Riesgo';
        System.debug(potencial);
        try {
            errorIsNotNull = false;
            TrgController.setDoNotRunTrigger();
            Database.update(potencial, true);
            successIsNotNull = true;
            successDetail = '¡Envío completado!';
        } catch (DmlException dmlEx1) {
            errorIsNotNull = true;
            successIsNotNull = false;
            System.debug(dmlEx1);
            errorDetail = dmlEx1.getMessage();
        }
    }
}