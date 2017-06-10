package Finance::GDAX::Request;
use v5.20;
use warnings;
use JSON;
use Moose;
use REST::Client;
use MIME::Base64;
use Digest::SHA qw(hmac_sha256_base64);
use Finance::GDAX::URL;
use namespace::autoclean;

=head1 NAME

Finance::GDAX::Request - Build and sign a GDAX REST request

=head1 SYNOPSIS

  $req = Finance::GDAX::Request->new( key        => 'My API Key',
                                      secret     => 'My API Secret Key',
                                      passphrase => 'My API Passphrase');
  $req->path('accounts');
  $cb_access_sign = $req->signature;

=head1 DESCRIPTION

Creates a signed GDAX REST request.

=head1 ATTRIBUTES

=head2 C<debug> (default: 1)

Use debug mode (sandbox) or prouduction. By default requests are done
with debug mode enabled which means connections will be made to the
sandbox API. To do live data, you must set debug to 0.

=head2 C<key> (required)

The GDAX API key

=head2 C<secret> (required)

The GDAX API secret key

=head2 C<passphrase> (required)

The GDAX API passphrase

=head2 C<method> (default: POST)

REST method to use when data is submitted. Must be in upper-case.

=head2 C<path>

The URI path for the REST method, which must be set or errors will
result. Leading '/' is not required.

=head2 C<body>

A reference to an array or hash that will be JSONified and represents
the data being sent in the REST request body. This is optional.

=head2 C<timestamp> (default: current unix epoch)

An integer representing the Unix epoch of the request. This defaults
to the current epoch time and will remain so as long as this object
exists.

=head2 C<timeout> (default: none)

Integer time in seconds to wait for response to request.

=cut

has 'debug' => (is  => 'rw',
		isa => 'Bool',
		default => 1,
    );
has 'key' => (is  => 'rw',
	      isa => 'Str',
	      required => 1,
    );
has 'secret' => (is  => 'rw',
		 isa => 'Str',
		 required => 1,
    );
has 'passphrase' => (is  => 'rw',
		     isa => 'Str',
		     required => 1,
    );
has 'method' => (is  => 'rw',
		 isa => 'Str',
		 default => 'POST',
    );
has 'path' => (is  => 'rw',
	       isa => 'Str',
    );
has 'body' => (is  => 'rw',
	       isa => 'Ref',
    );
has 'timestamp' => (is  => 'ro',
		    isa => 'Int',
		    default => sub { time },
    );
has 'timeout' => (is  => 'rw',
		  isa => 'Int',
    );

=head1 METHODS

=head2 C<signature>

Returns a string, base64-encoded representing the HMAC digest
signature of the request, generated from the secrey key.

=cut

sub signature {
    my $self = shift;
    my $json = JSON->new;
    my $data = $self->timestamp
	.$self->method
	.$self->path;
    $data .= $self->body_json if $self->body;
    my $digest = hmac_sha256_base64($data, decode_base64($self->secret));
    while (length($digest) % 4) {
	$digest .= '=';
    }
    return $digest;
}

=head2 C<body_json>

Returns a string, the JSON-encoded representation of the data
structure referenced by the "body" attribute.

=cut

sub body_json {
    my $self = shift;
    return JSON->new->encode($self->body);
}

sub send {
    my $self = shift;
    my $client = REST::Client->new;
    my $url    = Finance::GDAX::URL->new(debug => $self->debug);
    
    $url->add($self->path);
    
    $client->addHeader('CB-ACCESS-KEY',        $self->key);
    $client->addHeader('CB-ACCESS-SIGN',       $self->signature);
    $client->addHeader('CB-ACCESS-TIMESTAMP',  $self->timestamp);
    $client->addHeader('CB-ACCESS-PASSPHRASE', $self->passphrase);

    my $method = $self->method;
    $client->setTimetout($self->timeout) if $self->timeout;
    $client->$method($url->get);
    return {code => $client->responseCode, content => $client->responseContent};
}

__PACKAGE__->meta->make_immutable;
1;
