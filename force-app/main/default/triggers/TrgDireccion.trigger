trigger TrgDireccion on ERUM_Direcciones_Envio__c (after insert, after update) {
    if(TrgController.shouldRunTrigger()){
        new TrgControllerDireccion();
    }
}