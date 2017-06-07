use v5.20;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    use_ok('Finance::GDAX::Quote');
}

my $quote = Finance::GDAX::Quote->new;
isa_ok($quote, 'Finance::GDAX::Quote');

my $q = $quote->get;
is(ref($q), 'HASH', 'quote->get returns a hashref');
ok($$q{price} > 1, 'quote->get returns a price looking like a number');

done_testing();
