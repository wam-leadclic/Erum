trigger TrgAccount on Account (after insert, after update) {
    if(TrgController.shouldRunTrigger()){
        new TrgControllerAccount();
    }
}