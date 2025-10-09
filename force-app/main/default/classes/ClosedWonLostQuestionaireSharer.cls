public without sharing class ClosedWonLostQuestionaireSharer {
    // Child → Opportunity lookup API name
    public static final String FLD_OPPORTUNITY = 'Opportunity__c';

    // Use string literal for RowCause instead of enum to avoid compile issues
    private static final String RC_MANUAL = 'Manual';

    // Public Group that must have READ (for "everyone else = view only")
    // Change to your actual group name if different, or leave null to skip.
    public static final String READ_GROUP_NAME = 'All Internal Users';

    private static Id READ_GROUP_ID;
    private static Id readGroupId() {
        if (READ_GROUP_ID != null) return READ_GROUP_ID;
        try {
            Group g = [
                SELECT Id, Name, Type
                FROM Group
                WHERE Name = :READ_GROUP_NAME
                LIMIT 1
            ];
            READ_GROUP_ID = g.Id;
        } catch (Exception e) {
            READ_GROUP_ID = null; // group not found → skip group sharing
        }
        return READ_GROUP_ID;
    }

    /**
     * Ensure:
     *  - EDIT shares for Opp Owner + Opportunity.CS_Assignee__c
     *  - READ share for configured Public Group (so others have view only)
     * Also removes stale EDIT shares for ex-owner/assignee (does NOT touch group READ).
     */
    public static void applyForSurveys(List<Closed_Won_Lost_Questionaire__c> recs) {
        if (recs == null || recs.isEmpty()) return;

        // Collect related Opportunities
        Set<Id> oppIds = new Set<Id>();
        for (Closed_Won_Lost_Questionaire__c r : recs) {
            Id oppId = (Id) r.get(FLD_OPPORTUNITY);
            if (oppId != null) oppIds.add(oppId);
        }

        // Query Opp Owner + CS_Assignee__c
        Map<Id, Opportunity> oppById = new Map<Id, Opportunity>();
        if (!oppIds.isEmpty()) {
            oppById = new Map<Id, Opportunity>([
                SELECT Id, OwnerId, CS_Assignee__c
                FROM Opportunity
                WHERE Id IN :oppIds
            ]);
        }

        // Load existing MANUAL shares for these survey records
        Set<Id> surveyIds = new Map<Id, Closed_Won_Lost_Questionaire__c>(recs).keySet();
        Map<Id, List<Closed_Won_Lost_Questionaire__Share>> existingByParent = new Map<Id, List<Closed_Won_Lost_Questionaire__Share>>();
        if (!surveyIds.isEmpty()) {
            for (Closed_Won_Lost_Questionaire__Share sh : [
                SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause
                FROM Closed_Won_Lost_Questionaire__Share
                WHERE ParentId IN :surveyIds
                  AND RowCause = :RC_MANUAL
            ]) {
                List<Closed_Won_Lost_Questionaire__Share> bucket = existingByParent.get(sh.ParentId);
                if (bucket == null) {
                    bucket = new List<Closed_Won_Lost_Questionaire__Share>();
                    existingByParent.put(sh.ParentId, bucket);
                }
                bucket.add(sh);
            }
        }

        Id groupId = readGroupId(); // may be null if group not found
        List<Closed_Won_Lost_Questionaire__Share> toUpsert = new List<Closed_Won_Lost_Questionaire__Share>();
        List<Closed_Won_Lost_Questionaire__Share> toDelete = new List<Closed_Won_Lost_Questionaire__Share>();

        for (Closed_Won_Lost_Questionaire__c r : recs) {
            Id surveyId = r.Id;

            // Desired EDITors
            Set<Id> desiredEditors = new Set<Id>();
            Id oppId = (Id) r.get(FLD_OPPORTUNITY);
            if (oppId != null) {
                Opportunity o = oppById.get(oppId);
                if (o != null) {
                    if (o.OwnerId != null)        desiredEditors.add(o.OwnerId);
                    if (o.CS_Assignee__c != null) desiredEditors.add(o.CS_Assignee__c);
                }
            }

            // Existing MANUAL shares
            List<Closed_Won_Lost_Questionaire__Share> existingList =
                existingByParent.containsKey(surveyId) ? existingByParent.get(surveyId) : new List<Closed_Won_Lost_Questionaire__Share>();
            Set<Id> existingUsersOrGroups = new Set<Id>();
            Boolean hasGroupRead = false;

            for (Closed_Won_Lost_Questionaire__Share ex : existingList) {
                existingUsersOrGroups.add(ex.UserOrGroupId);
                if (groupId != null && ex.UserOrGroupId == groupId && ex.AccessLevel == 'Read') {
                    hasGroupRead = true;
                }
            }

            // Ensure EDIT for desired users
            for (Id uid : desiredEditors) {
                if (!existingUsersOrGroups.contains(uid)) {
                    Closed_Won_Lost_Questionaire__Share s = new Closed_Won_Lost_Questionaire__Share();
                    s.ParentId      = surveyId;
                    s.UserOrGroupId = uid;
                    s.AccessLevel   = 'Edit';
                    s.RowCause      = RC_MANUAL;
                    toUpsert.add(s);
                }
            }

            // Ensure READ for the group (others get view only)
            if (groupId != null && !hasGroupRead) {
                Closed_Won_Lost_Questionaire__Share gsh = new Closed_Won_Lost_Questionaire__Share();
                gsh.ParentId      = surveyId;
                gsh.UserOrGroupId = groupId;
                gsh.AccessLevel   = 'Read';
                gsh.RowCause      = RC_MANUAL;
                toUpsert.add(gsh);
            }

            // Remove stale EDIT shares for ex-owner/assignee (don’t touch group Read)
            for (Closed_Won_Lost_Questionaire__Share ex : existingList) {
                if (ex.AccessLevel == 'Edit' && !desiredEditors.contains(ex.UserOrGroupId)) {
                    toDelete.add(ex);
                }
            }
        }

        if (!toUpsert.isEmpty()) upsert toUpsert;
        if (!toDelete.isEmpty()) delete toDelete;
    }

    // Re-apply for all child records under given Opportunities (owner/assignee change)
    public static void reapplyForOpportunities(Set<Id> oppIds) {
        if (oppIds == null || oppIds.isEmpty()) return;

        List<Closed_Won_Lost_Questionaire__c> children = [
            SELECT Id, Opportunity__c
            FROM Closed_Won_Lost_Questionaire__c
            WHERE Opportunity__c IN :oppIds
        ];
        if (!children.isEmpty()) {
            applyForSurveys(children);
        }
    }
}