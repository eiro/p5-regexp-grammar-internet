package Regexp::Grammar::Internet;
use Eirotic;
use Regexp::Grammars;
our ($AUTHORITY, $VERSION) = qw( 0.0.0 cpan:MARCC );

qr{ <grammar: IP::Addr>

    # from ABNF found in https://tools.ietf.org/html/rfc5954
    # (ABNF itself is    https://tools.ietf.org/html/rfc5234)
    
    <rule: decByte>
        # thanks to ben, we read
        # https://tools.ietf.org/html/draft-main-ipaddr-text-rep-02
        # (section section 2.1.3)
        # which means 010 is not a valid version of 10
        # as we don't know if the leading 0 means "octal"

        2 (?: [0-4][0-9] | 5[0-5] )  # 200 to 255
        | 1\d{2}                     # 100 to 199
        | [1-9]\d                    # 10  to 99
        | \d                         # 0   to 9

    #  hexseq         =  hex4 *( ":" hex4)
    #  hex4           =  1*4HEXDIG
    <rule: hexseq> <.hex4=([[:xdigit:]]{1,4})>+ % \:

    #  hexpart        =  hexseq / hexseq "::" [ hexseq ] / "::" [ hexseq ]
    <rule: hexpart>
        (?: <.hexseq>? \:\: <.hexseq>? )
        | <.hexseq>

    #  IPv4address    =  1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT 
    <rule: IPv4address> <.decByte>{4} % \.

    #  IPv6address    =  hexpart [ ":" IPv4address ]
    <rule: IPv6address> <.hexpart> (?: \: <.IPv4address> )?

    #  IPv6reference  =  "[" IPv6address "]"
    <rule:IPv6reference> \[ <IPv6address> \]


}x
