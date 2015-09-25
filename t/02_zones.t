use Regexp::Grammars;
use Regexp::Grammar::Internet;
use Eirotic;
use lib 't';
use suite;
use Test::More;

my @test_atoms =
( [ comment => qr{ <extends: IP::Addr> ^ <found=comment> $ }x
    , ["; this is a comment" ]
    , ["this is just a string"] ]
);

my @test_vars =
( [ '$ttl 23424'  => {qw( key ttl value 23424 )} ]
, [ '$origin  u.' => {qw( key origin value u. )} ]
);

my $number_of_atoms =  suite::count_atom_yn @test_atoms;
diag "atoms to test: $number_of_atoms".

plan tests =>
( $number_of_atoms + 
+ @test_vars );

for (@test_vars) {
    my ($from,$expected) = @$_;
    my $got = 
        ( $from =~ qr{ <extends: IP::Addr> ^ <found=var> $ }x
        ? +{ %{$/{found}}{qw( key value )} }
        : undef );
    is_deeply $got, $expected, qq(found key/value pair in "$from")
        or diag( defined $got ? "parsing failure" : YAML::Dump $got );
}

suite::atom_yn for @test_atoms;
