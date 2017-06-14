use v5.20;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    use_ok('JSON');
    use_ok('Finance::GDAX::API::Quote');
    use_ok('Finance::GDAX::API::Request');
}

my $quote = Finance::GDAX::Quote->new;
isa_ok($quote, 'Finance::GDAX::API::Quote');

my $q = $quote->get;
is(ref($q), 'HASH', 'quote->get returns a hashref');
ok($$q{price} > 1, 'quote->get returns a price looking like a number');

my $req = Finance::GDAX::Request->new(key        => 'temp',
				      secret     => 'temp',
				      passphrase => 'temp');
ok($req->timestamp >= time, 'request timestamp appears sane');

$req->path('test');
ok(is_base64($req->signature), 'request WITHOUT body signature is base64');
$req->body({ test => 1, string => 'My test is a body test' });
ok(is_base64($req->signature), 'request WITH body signature is base64');

ok(${JSON->new->decode($req->body_json)}{string} eq "My test is a body test", 'body encoded to JSON');

ok(my $r = $req->send, 'send seems to work');
is($$r{code}, 400, 'valid REST return code');
ok($$r{content} =~ /^\{.+\}$/, 'valid REST content returned');

my $tf = "/tmp/gdax_ext_test";
my $key = "thisisthekey";
my $sec = "ThisISTHeSEcret";
my $pas = "MyverYSEcReTPasSPHraSe";
open TF, ">", $tf;
print TF "key:$key\n";
print TF "secret:$sec\n";
print TF "\n";
print TF "passphrase:$pas\n";
close TF;
$req->external_secret($tf);
unlink $tf;
is($req->key, $key, 'external_secret key read ok');
is($req->secret, $sec, 'external_secret secret read ok');
is($req->passphrase, $pas, 'external_secret passphrase read ok');

open TF, ">", $tf;
print TF <<"EOB";
#!/usr/bin/env perl
print "key:$key\n";
print "secret:$sec\n";
print "# This is a comment\n";
print "passphrase:$pas\n";
EOB
close TF;
chmod 0744, $tf;
$req->external_secret($tf, 1);
unlink $tf;
is($req->key, $key, 'external_secret forked key read ok');
is($req->secret, $sec, 'external_secret forked secret read ok');
is($req->passphrase, $pas, 'external_secret forked passphrase read ok');

done_testing();

sub is_base64 {
    my $string = shift;
    return $string =~
	m{
             ^
		 (?: [A-Za-z0-9+/]{4} )*
		 (?:
		  [A-Za-z0-9+/]{2} [AEIMQUYcgkosw048] =
		  |
		  [A-Za-z0-9+/] [AQgw] ==
		 )?
		 \z
            }x
	? 1 : 0;
}
