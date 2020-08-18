public with sharing class OfxFileGenerator {

    private String bankId;
    private String accountId;
    private String accountType;
    private List<TransactionWrapper> transactions;
    private String transCurrency;

    public OfxFileGenerator(String bankId, String accountId, String accountType, String tCurrency, List<TransactionWrapper> sourceTransactions) {
        this.bankId = bankId;
        this.accountId = accountId;
        this.accountType = accountType;
        this.transCurrency = tCurrency;
        this.transactions = sourceTransactions;
    }

    public String generateAndSave() {
        return this.ofxTemplate();
    }

    private String createFile(String data) {
        String fileName = 'OFX_Example_' + this.transCurrency + '_bankId_' + bankId + '_accountId_' + accountId;
        List<ContentVersion> doc = [SELECT Title FROM ContentVersion WHERE Title = :fileName LIMIT 1];

        if (doc.isEmpty()) {
            doc.add(new ContentVersion (
                    Title          = fileName,
                    PathOnClient   = fileName + '.ofx',
                    VersionData    = Blob.valueOf(data),
                    IsMajorVersion = false
            ));
        } else {
            doc.get(0).VersionData = Blob.valueOf(data);
        }

        try {
            upsert doc.get(0);
        } catch (Exception e) {

        }

        return '/' + doc.get(0).Id;
    }

    private String ofxTemplate() {
        List<String> ofxTransactionList = new List<String>();
        for (TransactionWrapper ofxField : this.transactions) {

            Decimal amountTransaction  = TransactionWrapper.TransactionTypeOFX.PAYMENT.name() != ofxField.transBaseType
                ? ofxField.amount
                : ofxField.amount - (ofxField.amount * 2);

            ofxTransactionList.add(
                '<STMTTRN>\n' +
                    '<TRNTYPE>' + ofxField.transBaseType  + '\n' +
                    '<DTPOSTED>' + String.valueOf(ofxField.postDate).replace('-', '')  + '\n' +
                    '<TRNAMT>' + amountTransaction  + '\n' +
                    '<FITID>' + Math.abs(Crypto.getRandomInteger())  + '\n' +
                    '<NAME>' + ofxField.description  + '\n' +
                '</STMTTRN>\n'
            );
        }

        String ofxData =
            'OFXHEADER:100\n' +
            'DATA:OFXSGML\n' +
            'VERSION:102\n' +
            'SECURITY:NONE\n' +
            'ENCODING:USASCII\n' +
            'CHARSET:1252\n' +
            'COMPRESSION:NONE\n' +
            'OLDFILEUID:NONE\n' +
            'NEWFILEUID:NONE\n' +

            '<OFX>\n'+
            '<STMTTRNRS>\n' +
            '<STMTRS>\n' +
            '<CURDEF>' + this.transCurrency + '\n' +
            '<BANKACCTFROM>\n' +
            '<BANKID>' + this.bankId + '\n' +
            '<ACCTID>' + this.accountId + '\n' +
            '<ACCTTYPE>' + this.accountType + '\n' +
            '</BANKACCTFROM>\n' +
                String.join(ofxTransactionList, '') +
            '</STMTRS>\n' +
            '</STMTTRNRS>\n' +

            '</OFX>';

        return createFile(ofxData);
    }


}