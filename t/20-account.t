use v5.20;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    use_ok('Finance::GDAX::API::Account');
}

my $account = new_ok('Finance::GDAX::API::Account');
can_ok($account, 'get_all');
can_ok($account, 'get');
can_ok($account, 'history');
can_ok($account, 'holds');
 
 SKIP: {
     skip 'GDAX_* environment variables not set', 8
	 unless (($ENV{GDAX_EXTERNAL_SECRET} || $ENV{GDAX_EXTERNAL_SECRET_FORK}) ||
		 ($ENV{GDAX_API_KEY} && $ENV{GDAX_API_SECRET} && $ENV{GDAX_API_PASSPHRASE})
	 );
     if ($ENV{GDAX_EXTERNAL_SECRET_FORK}) {
	 warn "GDAX external_secret forking here - stdout will not be visible, if you have to enter in passphrases\n";
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET_FORK}, 1), 'secret fork');
     } elsif ($ENV{GDAX_EXTERNAL_SECRET}) {
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET}), 'secret file');
     }

     $account->debug(1); # Make sure this is set to 1 or you'll use live data
     
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

     ok(my $history = $account->history($account_id), 'get BTC account history');
}

done_testing();

