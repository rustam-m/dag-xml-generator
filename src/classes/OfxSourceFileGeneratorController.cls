public with sharing class OfxSourceFileGeneratorController {

    public Date startDate                           { get; set; }
    public Integer step                             { get; set; }
    public Integer numberOfTransactions             { get; set; }
    public String transCurrency                     { get; set; }
    public List<TransactionWrapper> transactionList { get; set; }
    public String linkToFile                        { get; set; }

    public OfxSourceFileGeneratorController() {
        this.startDate = System.today();
        this.step      = 1;
        this.numberOfTransactions = 1;
    }

    public PageReference createTransactions() {
        try {
            transactionList = new List<TransactionWrapper>();

            Integer inc = 0;
            for (Integer i = 0; i < numberOfTransactions; i++) {
                transactionList.add(new TransactionWrapper(
                    getDescription(),
                    startDate.addDays(inc += step),
                    Math.round(Math.random() * (1000 - 1) + 1),
                    Math.round(Math.random() * 1) == 0 ? TransactionWrapper.TransactionTypeOFX.PAYMENT : TransactionWrapper.TransactionTypeOFX.CREDIT
                ));
            }

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        }
        return NULL;
    }


    public void generateOFX() {
        linkToFile = new OfxFileGenerator(transactionList, transCurrency).generateAndSave();
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

    private String getDescription() {
        return XmlCreatorTestData.DESCRIPTION_OFX.get(Math.round(Math.random() * (XmlCreatorTestData.DESCRIPTION_OFX_SIZE - 1)));
    }



}