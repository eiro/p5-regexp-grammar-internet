use Test::More;
use Regexp::Grammars;
use Regexp::Grammar::Internet;
use Eirotic;
use lib 't';
use suite;

my @test_atoms =
( [ decByte => qr{ <extends: IP::Addr> ^ <found=decByte> $  }x
    , [qw( 123 234 0 1 255 )]
    , [qw( 345 000 010 256 )] ]

, [ IPv4address => qr{ <extends: IP::Addr> ^ <found=IPv4address> $ }x
    , [qw( 234.0.1.255 )]
    , [qw( 0.1.255 234.0.1.255.2 345.000.010.256 )] ]

, [ hexseq => qr{ <extends: IP::Addr> ^ <found=hexseq> $ }x
    , [qw( 23 0 f ff )]
    , [qw( fg -2 )] ]

, [ hexpart => qr{ <extends: IP::Addr> ^ <found=hexpart> $ }x
    , [qw( ::23 0:: :: ff )]
    , [qw( ::23:: )] ]

, [ IPv6address => qr{ <extends: IP::Addr> ^ <found=IPv6address> $ }x
    , [qw(
        ::ffff:192.0.2.128
        ::ffff:c000:280 2001:db8::9:1
        0:0:0:0:0:FFFF:129.144.52.38
        ::FFFF:129.144.52.38
        )]
    , [qw(  )] ]

, [ hostname => qr{ <extends: IP::Addr> ^ <found=hostname> $ }x
    , [qw( host.example.com www.phear.org n0.re.re u and-.test )]
    , [qw( $this _haha )] ]

, [ dnsname => qr{ <extends: IP::Addr> ^ <found=dnsname> $ }x
    , [qw( host.example.com. www.phear.org. n0.re.re. u. and-.test. )]
    , [qw( $this _haha )] ]

);

plan tests => suite::count_atom_yn @test_atoms;
suite::atom_yn for @test_atoms;
