use v5.20;
use warnings;
use Test::More;
use Test::Exception;
use lib qw(lib t/lib);
use GDAXTestHelper;

BEGIN {
    use_ok('Finance::GDAX::API::Position');
}

my $position = new_ok('Finance::GDAX::API::Position');
can_ok($position, 'repay_only');
can_ok($position, 'get');
can_ok($position, 'close');

dies_ok { $position->repay_only('badtype') } 'repay_only dies good on bad values';
ok ($position->repay_only(1), 'repay_only can be set to known good value');
    
 SKIP: {
     my $secret = GDAX_environment_vars();
     my $skipnum = 0;
     if ($secret) { $skipnum = $secret ne 'RAW ENVARS' ? 3 : 2 };
     skip 'GDAX_* environment variables not set', $skipnum unless $secret ;

     unless ($secret eq 'RAW ENVARS') {
	 ok($position->external_secret($$secret[0], $$secret[1]), 'external secrets');
     }
     
     $position->debug(1); # Make sure this is set to 1 or you'll use live data

     #ok (my $result = $position->initiate, 'can get all funding');
     #is (ref $result, 'ARRAY', 'get returns array');
}

done_testing();

