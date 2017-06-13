use v5.20;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    use_ok('Finance::GDAX::Account');
}

my $account = new_ok('Finance::GDAX::Account');
 
 SKIP: {
     skip 'GDAX_EXTERNAL_SECRET environment variable not set', 7
	 unless ($ENV{GDAX_EXTERNAL_SECRET} || $ENV{GDAX_EXTERNAL_SECRET_FORK});
     if ($ENV{GDAX_EXTERNAL_SECRET_FORK}) {
	 warn "GDAX external_secret forking here - stdout will not be visible, if you have to enter in passphrases\n";
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET_FORK}, 1), 'secret fork');
     } else {
	 ok($account->external_secret($ENV{GDAX_EXTERNAL_SECRET}), 'secret file');
     }

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
     use Data::Dumper; warn Dumper($info);
}

done_testing();

