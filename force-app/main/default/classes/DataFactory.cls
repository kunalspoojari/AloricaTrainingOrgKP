public class DataFactory {

    private AccountFactory af;
    private CaseFactory cf;
    private OpportunityFactory opf;
    private SolarBotFactory sbf;
    private SolarBotStatusFactory sbsf;

    class DataFactoryException extends Exception {}

    public DataFactory() {
        af = new AccountFactory();
        cf = new CaseFactory();
        opf = new OpportunityFactory();
        sbf = new SolarBotFactory();
        sbsf = new SolarBotStatusFactory();
    }

    public Id generateData() {
        // Check for concurrent BatchRecordCreator jobs
        Id runningJobId = BatchRecordCreator.getRunningJobId();
        if (runningJobId != null) {
            throw new DataFactoryException('Can only run one BatchRecordCreator job at time. Found existing job: ' + runningJobId);
        }

        // Clean previously generated data
        af.deleteGeneratedAccountsAndRelatedRecords();

        // Generate and insert accounts
        List<Account> accounts = af.generate();
        insert accounts;

        // Prepare containers
        List<Case> cases = new List<Case>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<SolarBot_Status__c> statuses = new List<SolarBot_Status__c>();
        List<Contact> contacts = new List<Contact>();
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

        // Create contacts for all accounts first (bulk)
        for (Account account : accounts) {
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'testcontact' + Math.abs(Crypto.getRandomInteger()) + '@example.com',
                AccountId = account.Id
            );
            contacts.add(con);
        }

        // Bulk insert contacts
        insert contacts;

        // Map each contact to its account
        for (Contact con : contacts) {
            accountIdToContact.put(con.AccountId, con);
        }

        // Now loop through each account and generate related data
        for (Account account : accounts) {
            // Generate Cases
            cases.addAll(cf.generate(account));

            // Get contact for the account and generate Opportunities
            Contact contact = accountIdToContact.get(account.Id);
            opportunities.addAll(opf.generate(account, contact));

            // Generate SolarBots
            List<SolarBot__c> bots = sbf.generate(account);
            insert bots;

            // Generate statuses for each bot
            for (SolarBot__c bot : bots) {
                statuses.addAll(sbsf.generate(bot));
            }
        }

        // Insert Cases and Opportunities
        insert cases;
        insert opportunities;

        // Skip batch job in test context
        if (Test.isRunningTest()) {
            return null;
        }

        // Run batch job to insert statuses
        BatchRecordCreator batchCreator = new BatchRecordCreator(statuses);
        return Database.executeBatch(batchCreator, 5000);
    }

    public boolean hasSampleData() {
        Integer botCount = Database.countQuery('SELECT COUNT() FROM SolarBot__c');
        return (botCount != 0);
    }
}