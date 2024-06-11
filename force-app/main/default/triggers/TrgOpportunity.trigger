trigger TrgOpportunity on Opportunity (after insert, after update) {
    if(TrgController.shouldRunTrigger()){
        new TrgOpportunityController();
    }
}