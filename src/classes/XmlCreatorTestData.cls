public with sharing class XmlCreatorTestData {

    public static final List<String> DESCRIPTION_BANK = new List<String> {
        'Debit Card Purchase XX/XX XX:XXp #XXXXUW HUSKYTEAMBKSTORE XXX-XXX-XXXX WA XXXXX',
        'AUTOZONE 1299',
        'ACH Electronic CreditPERSONAL CAPITAL DEPOSIT',
        'BUFFALO WILD WIN GS 051',
        'ACH Electronic Debit - CITIBANK XFER TRANSFERXXXXXXXXXX',
        'Cash Withdrawal XX/XX XX:XXp #XXXXTeller',
        'Interest Payment',
        'Transfer'
    };


    public static final List<String> DESCRIPTION_CREDIT_CARD = new List<String> {
        'Audible audible.com NJ 1SZQH6HQ11T AUDIO BOOKS',
        'WWW.SHEIN.COM CALIFORNIA CA',
        'LINKEDIN-423*8709343LNKD.IN/BIL 1092479801- SUBSCRIPTION',
        'WWW.ITUNES.COM/BILL CUPERTINO CA MM4SK08Q1ZA DIRECT MKTG INTERNET',
        'GOOGLE *YOUTUBE TV 815-816-3981 A099GQWX SELLER',
        'JETBLUE AIRWAYS 9090JETBLUE NY BQUVGK 8005382581',
        'LA FITNESS CORP INTLIRVINE CA I475023715 MEMBERSHIP FEES',
        'THE HOME DEPOT  0540 RICHLAND HLS TX',
        'AUTOMATIC PAYMENT - THANK',
        'LOWE\'S OF HURST, TX HURST TX',
        'PANERA BREAD  XXXXXX EULESS TX',
        'FARMERS INS BILLING 877-327-6392 CA',
        'PAYPAL *HUGEOFF.COM 402-935-7733 CA',
        'THE HOME DEPOT  6534 FT. WORTH TX'
    };


    public static final Integer DESCRIPTION_BANK_SIZE {
        get { return XmlCreatorTestData.DESCRIPTION_BANK.size(); }
        set;
    }

    public static final Integer DESCRIPTION_CREDIT_CARD_SIZE {
        get { return XmlCreatorTestData.DESCRIPTION_CREDIT_CARD.size(); }
        set;
    }


    public static final Map<String, List<String>> TRANSACTION_ATTRIBUTES = new Map<String, List<String>>{
            'debit' => new List<String>{
                    'debit', 'miscellaneousFee'
            },
            'credit' => new List<String>{
                    'interestPayment', 'deposit'
            }
    };

}