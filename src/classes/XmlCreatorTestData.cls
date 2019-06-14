public with sharing class XmlCreatorTestData {

    public static final List<String> DESCRIPTION_BANK = new List<String> {
        'Debit Card Purchase',
        'AUTOZONE 1299',
        'ACH Electronic',
        'BUFFALO WILD WIN',
        'ACH Electronic Debit',
        'Cash Withdrawal',
        'Interest Payment',
        'Reebok 122',
        'Nike Inc.',
        'Transfer',
        'Wings of sky INC.',
        'Yellow Island 21',
        'WIN 2000 INC.',
        'Reengo XXI'
    };

    public static final List<String> DESCRIPTION_CREDIT_CARD = new List<String> {
        'Audible audible.com NJ',
        'WWW.SHEIN.COM',
        'LINKEDIN',
        'WWW.ITUNES.COM/BILL CUPERTINO CA',
        'GOOGLE *YOUTUBE TV',
        'JETBLUE AIRWAYS',
        'LA FITNESS CORP',
        'THE HOME DEPOT',
        'AUTOMATIC PAYMENT - THANK',
        'LOWE\'S OF HURST',
        'PANERA BREAD',
        'FARMERS INS',
        'PAYPAL',
        'ORACLE CA',
        'NETFLIX NY',
        'FLOWER 20X',
        'ROOM 24H',
        'DREAM INS'
    };

    public  static final List<String> DESCRIPTION_OFX =  new List<String> {
        'NRM Ltd',
        'Donald D',
        'John Hancock',
        'Tesco',
        'ADIDAS',
        'Apple',
        'Columbia',
        'Cinemax',
        'Amazon',
        'FeedEx',
        'RHD Co',
        'MAX XQ',
        'PANERA BREAD',
        'LA FITNESS CORP',
        'PAYPAL'
    };

    public static final Integer DESCRIPTION_OFX_SIZE {
        get { return XmlCreatorTestData.DESCRIPTION_OFX.size(); }
        set;
    }

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