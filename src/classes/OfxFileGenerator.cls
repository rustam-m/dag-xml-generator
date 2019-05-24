public with sharing class OfxFileGenerator {

    private List<TransactionWrapper> transactions;
    private String transCurrency;

    public OfxFileGenerator(List<TransactionWrapper> sourceTransactions, String tCurrency) {
        this.transactions  = sourceTransactions;
        this.transCurrency = tCurrency;
    }

    public String generateAndSave(){
        return this.ofxTemplate();
    }

    private String createFile(String data) {
        String fileName = 'Ofx_example';
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
                '<STMTTRN>' +
                    '<TRNTYPE>'  + ofxField.transBaseType +
                    '<DTPOSTED>' + String.valueOf(ofxField.postDate).replace('-', '') +
                    '<TRNAMT>'   + amountTransaction +
                    '<FITID>'    + Math.abs(Crypto.getRandomInteger()) +
                    '<NAME>'     + ofxField.description +
                '</STMTTRN>'
            );
        }

        String ofxData = 'DATA:OFXSGML3' +
                '<OFX>'+
                 '<CURDEF>' + this.transCurrency +
                     + String.join(ofxTransactionList,'') +
                 '</OFX>';

        return createFile(ofxData);
    }


}