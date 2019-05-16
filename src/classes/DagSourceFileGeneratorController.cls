public with sharing class DagSourceFileGeneratorController {

    public String  transactionType                   { get; set; }
    public Date    startDate                         { get; set; }
    public Integer step                              { get; set; }
    public String  accountName                       { get; set; }
    public Integer numberOfTransactions              { get; set; }
    public List<TransactionWrapper> transactionList  { get; set; }
    public String linkToFile                         { get; set; }
    public Decimal startBalance                      { get; set; }
    public Decimal availableBalance                  { get; set; }
    public Decimal currentBalance                    { get; set; }

    private static final String STATUS_POSTED = 'posted';

    //Constructor set default value;
    public DagSourceFileGeneratorController(){
        this.startDate = Date.today();
        this.step      = 1;
        this.numberOfTransactions = 1;
        this.startBalance = 10000;
        this.currentBalance   = this.startBalance;
    }

    public PageReference createTransactions() {
        try {

            String resValidation = dataValidation(numberOfTransactions, startDate);
            if (String.isNotBlank(resValidation)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resValidation));
                return null;
            }

            transactionList = new List<TransactionWrapper>();

            Integer inc = 0;
            Decimal maxNumber = (startBalance / numberOfTransactions) + 1;
            for (Integer i = 0; i < numberOfTransactions; i++) {
                transactionList.add(new TransactionWrapper(
                    getDescription(),
                    startDate.addDays(inc += step),
                    startDate.addDays(inc + 1),
                    Math.round(Math.random() * (maxNumber - 1) + 1),
                    Math.round(Math.random() * 1) == 0 ? TransactionWrapper.TransactionType.DEBIT : TransactionWrapper.TransactionType.CREDIT,
                    STATUS_POSTED
                )
                );

            }

            changeStatus();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(e)));
        }

        return null;
    }

    public void generateXML() {
        linkToFile = new DagXMLFileGenerator(transactionList, accountName, availableBalance, currentBalance).generateAndSave(transactionType);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'XML file has been successfully created.'));
    }

    public void changeStatus() {

        this.availableBalance = this.startBalance;
        this.currentBalance   = this.startBalance;

        for (TransactionWrapper field : transactionList) {
            if (field.transStatus == STATUS_POSTED) {
                this.availableBalance = this.availableBalance - field.amount;
                this.currentBalance   = this.currentBalance   - field.amount;
            } else {
                this.availableBalance = this.availableBalance - field.amount;
            }

            if (this.availableBalance < 0 || this.currentBalance < 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Available and Current balance can not be less than zero.'));
            }
        }
    }

    private String getDescription() {
        String description = '';
        if (transactionType == 'Bank') {
            description = XmlCreatorTestData.DESCRIPTION_BANK.get(Math.round(Math.random() * (XmlCreatorTestData.DESCRIPTION_BANK_SIZE - 1)));
        } else if (transactionType == 'Credits') {
            description = XmlCreatorTestData.DESCRIPTION_CREDIT_CARD.get(Math.round(Math.random() * (XmlCreatorTestData.DESCRIPTION_CREDIT_CARD_SIZE - 1)));
        }
        return description;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Credits', 'Credit Card'));
        options.add(new SelectOption('Bank', 'Bank'));
        return options;
    }

    public List<SelectOption> getBaseType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(TransactionWrapper.TransactionType.DEBIT.name().toLowerCase(),  TransactionWrapper.TransactionType.DEBIT.name()));
        options.add(new SelectOption(TransactionWrapper.TransactionType.CREDIT.name().toLowerCase(), TransactionWrapper.TransactionType.CREDIT.name()));
        return options;
    }

    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('pending', 'PENDING'));
        options.add(new SelectOption('posted',  'POSTED'));
        return options;
    }
    
    private String dataValidation(Integer numberTransaction, Date startDate) {
        if (numberTransaction >= 1000 || numberTransaction < 1) {
            return 'Number of transactions can be any number from 1 to 999';
        } else if (startDate > Date.today()) {
            return 'The due date can not be earlier then the issue date';
        }

        return NULL;
    }

}