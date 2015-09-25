package suite;
use Eirotic;
use Test::More;

sub count_atom_yn {
    my $count = 0;
    map {
        my ($yes,$no) = map $_||[], @{$_}[2,3];
        $count += ( @$yes * 2 ) + ( @$no * 1 );
    } @_;
    $count;
}

sub atom_yn :prototype(_) {
    my ($rule, $grammar, $yes, $no ) = @{shift,};
    map {
        ok
        ( ($_ =~ $grammar)
        , "$_ is a $rule");
        ok
        ( ($/{found} eq $_)
        , "$_ matched")
            or diag "$/{found}";
    } @{ $yes || [] };

    map {
        ok
        ( ($_ !~ $grammar)
        , "$_ is not a $rule")
            or diag "found $/{found}"
    } @{ $no || [] };
}

1;

