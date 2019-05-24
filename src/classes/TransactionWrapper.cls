public with sharing class TransactionWrapper {

    public String description            { get; set; }
    public Date transDate                { get; set; }
    public Date postDate                 { get; set; }
    public Decimal amount                { get; set; }
    public String  transStatus           { get; set; }
    public Integer numberTransaction     { get; set; }

    public enum TransactionType          { DEBIT, CREDIT }
    public enum TransactionTypeOFX       { CREDIT, PAYMENT }

    public String  transBaseType { get; set; }
    public String  transType     { get; set; }

    private static Integer count = 0;

    //    Constructor for XML file;
    public TransactionWrapper(String descr, Date transDate, Date postDate, Decimal amount, TransactionType type, String status) {
        this.description       = descr;
        this.transDate         = transDate;
        this.postDate          = postDate;
        this.amount            = amount.setScale(2);
        this.transBaseType     = type.name().toLowerCase();
        this.transStatus       = status;
        this.numberTransaction = ++count;
        this.transType         = this.setTransType();
    }

    //    Constructor for OFX file;
    public TransactionWrapper(String descr, Date postDate, Decimal amount, TransactionTypeOFX type) {
        this.description       = descr;
        this.postDate          = postDate;
        this.amount            = amount.setScale(2);
        this.transBaseType     = type.name();
        this.numberTransaction = ++count;
    }

    private String setTransType() {
        return XmlCreatorTestData.TRANSACTION_ATTRIBUTES.get(this.transBaseType).get(Math.round(Math.random() * 1));
    }

}