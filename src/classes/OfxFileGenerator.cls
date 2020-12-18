public with sharing class OfxFileGenerator {

    private String financialInstitutionId;
    private String financialInstitutionName;
    private Boolean isBank;
    private String accountId;
    private String accountType;
    private List<TransactionWrapper> transactions;
    private String transCurrency;

    public OfxFileGenerator(String fid, String fiName, Boolean isBank, String accountId, String accountType, String tCurrency, List<TransactionWrapper> sourceTransactions) {
        this.financialInstitutionId = fid;
        this.financialInstitutionName = fiName;
        this.isBank = isBank;
        this.accountId = accountId;
        this.accountType = accountType;
        this.transCurrency = tCurrency;
        this.transactions = sourceTransactions;
    }

    public String generateAndSave() {
        return this.ofxTemplate();
    }

    private String createFile(String data) {
        String fileName = 'OFX_Example_' +
            this.transCurrency +
            '_ORG_' + financialInstitutionName +
            '_FID_' + financialInstitutionId +
            '_accountId_' + accountId;
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

        String acctFrom = '';
        if (isBank) {
            acctFrom =
                '<BANKACCTFROM>\n' +
                    '<ACCTID>' + this.accountId + '\n' +
                    '<ACCTTYPE>' + this.accountType + '\n' +
                '</BANKACCTFROM>';
        }
        else {
            acctFrom =
                '<CCACCTFROM>\n' +
                    '<ACCTID>' + this.accountId + '\n' +
                '</CCACCTFROM>';
        }

        String ofxData =
            '<?xml version="1.0" encoding="utf-8" ?>\n' +
                '<?OFX OFXHEADER="200" VERSION="202" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>\n' +
                '<OFX>\n'+
                '<FI>\n' +
                '<ORG>' + financialInstitutionName + '</ORG>\n' +
                '<FID>' + financialInstitutionId + '</FID>\n' +
                '</FI>\n' +
                '<STMTTRNRS>\n' +
                '<STMTRS>\n' +
                '<CURDEF>' + this.transCurrency + '\n' +
                    acctFrom + '\n' +
                    String.join(ofxTransactionList, '') +
                '</STMTRS>\n' +
                '</STMTTRNRS>\n' +

                '</OFX>';

        return createFile(ofxData);
    }


}