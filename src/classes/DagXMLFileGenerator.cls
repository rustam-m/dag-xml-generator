public with sharing class DagXMLFileGenerator {

    private static String BANK_STUB = 'Bank';
    private static String CREDIT_CARD_STUB = 'Credits';

    private List<TransactionWrapper> transactions;
    private String accountName;
    private Decimal availableBalance;
    private Decimal currentBalance;

    public DagXMLFileGenerator(List<TransactionWrapper> sourceTransactions, String accName, Decimal aBalance, Decimal cBalance) {
        this.transactions = sourceTransactions;
        this.accountName = accName;
        this.availableBalance = aBalance;
        this.currentBalance = cBalance;
    }

    public DagXMLFileGenerator(List<TransactionWrapper> sourceTransactions) {
        this.transactions = sourceTransactions;
    }

    public String generateAndSave(String type) {
        String link = '';
        if (BANK_STUB == type) {
            link = bankTemplate(type);
        } else if (CREDIT_CARD_STUB == type) {
            link = cardTemplate(type);
        }
        return link;
    }

    private String createFile(String data, String type) {
        String fileName = 'Dag Site - ' + type;
        List<ContentVersion> xmlDoc = [SELECT Title FROM ContentVersion WHERE Title = :fileName LIMIT 1];

        if (xmlDoc.isEmpty()) {
            xmlDoc.add(new ContentVersion (
                Title          = fileName,
                PathOnClient   = fileName + '.xml',
                VersionData    = Blob.valueOf(data),
                IsMajorVersion = false
            ));
        } else {
            xmlDoc.get(0).VersionData = Blob.valueOf(data);
        }

        try {
            upsert xmlDoc.get(0);
        } catch (Exception e) {

        }

        return '/' + xmlDoc.get(0).Id;
    }

    private String bankTemplate(String type){
        List<String> bankTransactionList = new List<String>();

        for (TransactionWrapper items : this.transactions) {

            Datetime transDateTime = items.transDate;
            Datetime postDateTime  = items.postDate;

            String showPostDate = items.transStatus == 'posted'
                ? '<postDate localFormat="yyyy-MM-dd">' + transDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss') + '</postDate>'
                : '';

            bankTransactionList.add(
                 '<transaction baseType="'+ items.transBaseType +'" transactionStatus="' + items.transStatus + '" type="'+ items.transBaseType +'">'+
                    '<description>' + items.description + '</description>' +
                    '<transDate localFormat="yyyy-MM-dd">' + postDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss') + '</transDate>'+
                    showPostDate +
                    '<amount curCode="USD">' + items.amount + '</amount>' +
                    '<transactionRunningBalance curCode="USD">' + items.amount * 2 + '</transactionRunningBalance>' +
                '</transaction>'
            );
        }

        //Dag Checking Account
        String resXml = '<site>' +
            '<bankAccount nickName="Interest Checking-2345" acctType="checking" accountClassification="personal">'+
                '<accountName>' + this.accountName  +'</accountName>'+
                '<fullAccountNumber>123445682345</fullAccountNumber>'+
                '<accountNumber>2345</accountNumber>'+
                '<routingNumber>xxxxxxxxx</routingNumber>'+
                '<accountHolder>Robin</accountHolder>'+
                '<balance balType="availableBalance">'+
                    '<curAmt curCode="USD">' + this.availableBalance + '</curAmt>'+
                '</balance>'+
                '<balance balType="currentBalance">'+
                    '<curAmt curCode="USD">' + this.currentBalance + '</curAmt>'+
                '</balance>'+
                '<balance balType="overdraftProtection">'+
                    '<curAmt curCode="USD">2589.00</curAmt>'+
                '</balance>'+
                '<transactionList>'+ String.join(bankTransactionList,'') + '</transactionList>'+
            '</bankAccount>'+
            '</site>';

        return createFile(resXml, type);
    }

    private String cardTemplate(String type){
        List<String> cardTransactionList = new List<String>();
        for(TransactionWrapper items: this.transactions){

            Datetime transDateTime = items.transDate;
            Datetime postDateTime  = items.postDate;

            String showPostDate = items.transStatus == 'posted'
                    ? '<postDate localFormat="yyyy-MM-dd">' + transDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss') + '</postDate>'
                    : '';

            cardTransactionList.add(
                '<transaction transactionStatus="'+ items.transStatus +'" baseType="'+ items.transBaseType +'">' +
                     '<description>' + items.description + '</description>' +
                     '<transactionId>' + Math.abs(Crypto.getRandomInteger()) + '</transactionId>' +
                     '<transDate localFormat="yyyy-MM-dd">' + postDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss') + '</transDate>' +
                     showPostDate +
                     '<amount curCode="USD">' + items.amount + '</amount>' +
                 '</transaction>'
            );
        }
        //Dag Charge Card
        String resXml = '<site>' +
             '<cardAccount accountClassification="personal" acctType="charge">'+
                 '<accountName>' + this.accountName + '</accountName>'+
                 '<nickName>Traditional Gharge</nickName>'+
                 '<accountHolder>Jacob</accountHolder>'+
                 '<accountNumber>XXXX-XXXX-XXXX-3600</accountNumber>'+
                 '<balance balType="runningBalance">'+
                    '<curAmt curCode="USD">'+ this.currentBalance + '</curAmt>'+
                 '</balance>'+
                 '<asOf localFormat="yyyyMMdd">2018-10-20T00:00:00</asOf>'+
                 '<balance balType="amountDue">'+
                     '<curAmt curCode="USD">10418.00</curAmt>'+
                 '</balance>'+
                 '<balance balType="minPayment">'+
                     '<curAmt curCode="USD">550.00</curAmt>'+
                 '</balance>'+
                 '<balance balType="lastPayment">'+
                     '<curAmt curCode="USD">122.00</curAmt>'+
                 '</balance>'+
                 '<lastPaymentDate localFormat="yyyyMMdd">2018-09-18T00:00:00</lastPaymentDate>'+
                 '<balance balType="availableCredit">'+
                    '<curAmt curCode="USD">'+ this.availableBalance +'</curAmt>'+
                 '</balance>'+
                 '<balance balType="totalCreditLine">'+
                    '<curAmt curCode="USD">12000.00</curAmt>'+
                 '</balance>'+
                 '<dueDate localFormat="yyyyMMdd">2018-11-07T00:00:00</dueDate>'+
                 '<apr>19.99</apr>'+
                '<transactionList>'+ String.join(cardTransactionList,'') + '</transactionList>'+
             '</cardAccount>'+
        '</site>';

        return createFile(resXml, type);
    }
}