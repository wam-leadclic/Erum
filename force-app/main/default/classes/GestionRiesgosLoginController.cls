global with sharing class GestionRiesgosLoginController {

    global String username {get; set;}
    global String password {get; set;}
    global String errorDetail {get;set;}
    global Boolean errorIsNotNull {get; set;}

    global PageReference verificarCredenciales() {
        String cif = ApexPages.currentpage().getparameters().get('cif');
        List<Credencial__mdt> credenciales = [SELECT Id, Username__c, Password__c FROM Credencial__mdt];
        List<String> usersAndPasswords = new List<String>();
        for (Credencial__mdt credencial : credenciales) {
            usersAndPasswords.add(credencial.Username__c + credencial.Password__c);
        }
        PageReference reference = new PageReference('/GestionRiesgosPage?cif=' + cif);
        if (usersAndPasswords.contains(username + password)) {
            errorIsNotNull = false;
            reference.setRedirect(true);
            return reference;
        } else {
            errorDetail = 'Credenciales erróneas.';
            errorIsNotNull = true;
            return null;
        }
    }

    global GestionRiesgosLoginController() {
        errorIsNotNull = false;
    }
}