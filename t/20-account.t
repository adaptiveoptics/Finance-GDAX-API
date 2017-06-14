use v5.20;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    use_ok('Finance::GDAX::API::Account');
}

my $account = new_ok('Finance::GDAX::API::Account');
 
 SKIP: {
     skip 'GDAX_EXTERNAL_SECRET environment variable not set', 9
	 unless ($ENV{GDAX_EXTERNAL_SECRET} || $ENV{GDAX_EXTERNAL_SECRET_FORK});
     if ($ENV{GDAX_EXTERNAL_SECRET_FORK}) {
	 warn "GDAX external_secret forking here - stdout will not be visible, if you have to enter in passphrases\n";
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET_FORK}, 1), 'secret fork');
     } else {
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET}), 'secret file');
     }

     $account->debug(0); # Make sure this is set to 1 or you'll use live data
     
     ok(my $response = $account->get_all, 'get_all accounts list');
     my $rc = $account->response_code;
     is($rc, 200, 'Good 200 response code from accounts list');
     is(ref($response), 'ARRAY', 'get_all accounts returned an array');
     my $found;
     my $account_id;
     foreach (@$response) {
	 if ($$_{currency} eq 'BTC') {
	     $found = 1;
	     $account_id = $$_{id};
	     last;
	 }
     }
     ok($found, 'get_all accounts returns a BTC account');

     ok(my $info = $account->get($account_id), 'get BTC account');
     ok(defined $$info{balance}, 'BTC account has balance defined');

     foreach (@$response) {
	 my $history = $account->history($$_{id});
	 use Data::Dumper; warn Dumper($history)."\n";
     }
	 
     #ok(my $history = $account->history($account_id), 'get BTC account history');
     #warn $account->error if $account->error;
     #ok(defined ${$$history[0]}{amount}, 'BTC account history has an amount');
}

done_testing();

