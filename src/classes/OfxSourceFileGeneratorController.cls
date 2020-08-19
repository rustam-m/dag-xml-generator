public with sharing class OfxSourceFileGeneratorController {

    public DateTime startDate { get; set; }
    public Integer step { get; set; }
    public Integer numberOfTransactions { get; set; }
    public String transCurrency { get; set; }
    public List<TransactionWrapper> transactionList { get; set; }
    public String linkToFile { get; set; }
    public String bankId { get; set; }
    public String accountId { get; set; }
    public String accountType { get; set; }
    public Boolean isChromeBasedBrowser { get; set; }

    public OfxSourceFileGeneratorController() {
        this.startDate = System.now().addDays(-60);
        this.step = 1;
        this.numberOfTransactions = 1;
        this.bankId = '123456789';
        this.accountId = 'XXXXXXXXXXXX7019';
        this.accountType = 'CREDITLINE';
        this.isChromeBasedBrowser = ApexPages.currentPage().getHeaders().get('USER-AGENT').containsIgnoreCase('Chrome');
    }

    public PageReference createTransactions() {
        try {
            transactionList = new List<TransactionWrapper>();

            Integer extraHours = 0;
            for (Integer i = 0; i < numberOfTransactions; i++) {
                transactionList.add(new TransactionWrapper(
                    getDescription(),
                    getTransactionDate(extraHours),
                    Math.round(Math.random() * (1000 - 1) + 1),
                    Math.round(Math.random() * 1) == 0 ? TransactionWrapper.TransactionTypeOFX.PAYMENT : TransactionWrapper.TransactionTypeOFX.CREDIT
                ));
                extraHours = extraHours + step;
            }

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        }
        return null;
    }

    private Datetime getTransactionDate(Integer extraHours) {
        Datetime result = startDate.addHours(extraHours);
        if (result > System.now()) {
            result = System.now();
        }
        return result;
    }

    public void generateOFX() {
        linkToFile = new OfxFileGenerator(
            bankId,
            accountId,
            accountType,
            transCurrency,
            transactionList
        ).generateAndSave();

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'OFX file has been successfully created.'));
    }

    public List<SelectOption> getBaseType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(TransactionWrapper.TransactionTypeOFX.PAYMENT.name(),  TransactionWrapper.TransactionTypeOFX.PAYMENT.name()));
        options.add(new SelectOption(TransactionWrapper.TransactionTypeOFX.CREDIT.name(), TransactionWrapper.TransactionTypeOFX.CREDIT.name()));
        return options;
    }

    public List<SelectOption> getTransactionCurrency() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('USD',  'USD'));
        options.add(new SelectOption('EUR',  'EUR'));
        options.add(new SelectOption('CAD',  'CAD'));
        options.add(new SelectOption('GBP',  'GBP'));
        options.add(new SelectOption('JPY',  'JPY'));
        return options;
    }

    public List<SelectOption> getAccountTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('CHECKING', 'Checking'));
        options.add(new SelectOption('SAVINGS', 'Savings'));
        options.add(new SelectOption('MONEYMRKT', 'Money Market'));
        options.add(new SelectOption('CREDITLINE', 'Line of credit'));
        return options;
    }

    private String getDescription() {
        return XmlCreatorTestData.DESCRIPTION_OFX.get(Math.round(Math.random() * (XmlCreatorTestData.DESCRIPTION_OFX_SIZE - 1)));
    }



}