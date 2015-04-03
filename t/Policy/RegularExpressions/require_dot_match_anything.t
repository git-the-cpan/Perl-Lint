use strict;
use warnings;
use Perl::Lint::Policy::RegularExpressions::RequireDotMatchAnything;
use t::Policy::Util qw/fetch_violations/;
use Test::Base::Less;

my $class_name = 'RegularExpressions::RequireDotMatchAnything';

filters {
    params => [qw/eval/],
};

for my $block (blocks) {
    my $violations = fetch_violations($class_name, $block->input, $block->params);
    is scalar @$violations, $block->failures, $block->dscr;
}

done_testing;

__DATA__

===
--- dscr: basic passes
--- failures: 0
--- params:
--- input
my $string =~ m{pattern}s;
my $string =~ m{pattern}gisx;
my $string =~ m{pattern}gmis;
my $string =~ m{pattern}mgxs;

my $string =~ m/pattern/s;
my $string =~ m/pattern/gisx;
my $string =~ m/pattern/gmis;
my $string =~ m/pattern/mgxs;

my $string =~ /pattern/s;
my $string =~ /pattern/gisx;
my $string =~ /pattern/gmis;
my $string =~ /pattern/mgxs;

my $string =~ s/pattern/foo/s;
my $string =~ s/pattern/foo/gisx;
my $string =~ s/pattern/foo/gmis;
my $string =~ s/pattern/foo/mgxs;

my $re = qr/pattern/s;

===
--- dscr: basic failures
--- failures: 17
--- params:
--- input
my $string =~ m{pattern};
my $string =~ m{pattern}gix;
my $string =~ m{pattern}gim;
my $string =~ m{pattern}gxm;

my $string =~ m/pattern/;
my $string =~ m/pattern/gix;
my $string =~ m/pattern/gim;
my $string =~ m/pattern/gxm;

my $string =~ /pattern/;
my $string =~ /pattern/gix;
my $string =~ /pattern/gim;
my $string =~ /pattern/gxm;

my $string =~ s/pattern/foo/;
my $string =~ s/pattern/foo/gix;
my $string =~ s/pattern/foo/gim;
my $string =~ s/pattern/foo/gxm;

my $re = qr/pattern/;

===
--- dscr: tr and y checking
--- failures: 0
--- params:
--- input
my $string =~ tr/[A-Z]/[a-z]/;
my $string =~ tr|[A-Z]|[a-z]|;
my $string =~ tr{[A-Z]}{[a-z]};

my $string =~ y/[A-Z]/[a-z]/;
my $string =~ y|[A-Z]|[a-z]|;
my $string =~ y{[A-Z]}{[a-z]};

my $string =~ tr/[A-Z]/[a-z]/cd;
my $string =~ y/[A-Z]/[a-z]/cd;

===
--- dscr: use re '/s' - RT #72151
--- failures: 0
--- params:
--- input
use re '/s';
my $string =~ m{pattern.};

===
--- dscr: use re qw{ /s } - RT #72151
--- failures: 0
--- params:
--- input
use re qw{ /s };
my $string =~ m{pattern.};

===
--- dscr: use re qw{ /s } not in scope - RT #72151
--- failures: 1
--- params:
--- input
{
    use re qw{ /s };
}
my $string =~ m{pattern.};

===
--- dscr: no re qw{ /s } - RT #72151
--- failures: 1
--- params:
--- input
use re qw{ /smx };
{
    no re qw{ /s };
    my $string =~ m{pattern.};
}

===
--- dscr: no lint
--- failures: 4
--- params:
--- input
my $string =~ m{pattern};
my $string =~ m{pattern}gix;
my $string =~ m{pattern}gim; ## no lint
my $string =~ m{pattern}gxm;
my $string =~ m/pattern/;

