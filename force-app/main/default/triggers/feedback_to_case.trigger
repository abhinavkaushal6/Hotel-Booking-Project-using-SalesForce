trigger feedback_to_case on Customer_Feedback__c (after insert, after update) {
    List<Case> casesToInsert = new List<Case>();

    for (Customer_Feedback__c fb : Trigger.new) {
        if (fb.Customer_Satisfaction_Index__c <= 4.5) {
            Case case1 = new Case(
                Priority = 'High', 
                Origin = 'Phone', 
                ContactId = fb.Guest_name__c,  
                AccountId = fb.Hotel_name__c,
                Reason = 'Customer rating is too low - ' + fb.Customer_Satisfaction_Index__c + ' for ' + fb.Id,
                Subject = 'Low rating of ' + fb.Hotel_Name_c__c
            );
            casesToInsert.add(case1);
        }
    }

    if (!casesToInsert.isEmpty()) {
        try {
            insert casesToInsert;
            update Trigger.new;
        } catch (Exception e) {
            System.debug('Error creating cases: ' + e.getMessage());
        }
    }
}