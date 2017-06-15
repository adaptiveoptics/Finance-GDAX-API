use v5.20;
use warnings;
use Test::More;
use lib qw(lib t/lib);
use GDAXTestHelper;

BEGIN {
    use_ok('Finance::GDAX::API::Order');
}

my $order = new_ok('Finance::GDAX::API::Order');
#can_ok($account, 'get_all');

 
 SKIP: {
     my $secret;
     skip 'GDAX_* environment variables not set', 8 unless $secret = GDAX_environment_vars();

     unless ($secret eq 'RAW ENVARS') {
	 ok($order->external_secret($$secret[0], $$secret[1]), 'external secrets');
     }
     
     $order->debug(1); # Make sure this is set to 1 or you'll use live data     
}

done_testing();

