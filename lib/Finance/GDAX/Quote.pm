package Finance::GDAX::Quote;
use v5.20;
use warnings;
use Moose;
use JSON;
use REST::Client;
use Finance::GDAX::URL;
use namespace::autoclean;


=head1 NAME

Finance::GDAX::Quote - Get a quote from the GDAX

=head1 SYNOPSIS

  use Finanace::GDAX::Quote;
  my $quote = Finance::GDAX::Quote->new({product => 'BTC-USD'})->get;
  say $$quote{price};
  say $$quote{bid};
  say $$quote{ask};

=head1 DESCRIPTION

Gets a quote from the GDAX for the specified "product", which is
mostly just a currency.

Currently, the supported products are:

  BTC-USD
  BTC-GBP
  BTC-EUR
  ETH-BTC
  ETH-USD
  LTC-BTC
  LTC-USD
  ETH-EUR

These are not hard-coded, but the default is BTC-USD, so if any are
added by GDAX in the future, it should work find if you can find the
product code.

Quote is returned as a hashref with the (currently) following keys:

  trade_id
  price
  size
  bid
  ask
  volume
  time

=head1 ATTRIBUTES

=head2 C<debug>

Bool that sets debug mode (will use sandbox). Defaults to true
(1). Debug mode does not seem to give real quotes.

=head2 C<product>

The product code for which to return the quote.

=cut

has 'product' => (is  => 'rw',
		  isa => 'Str',
		  default => 'BTC-USD',
    );
has 'debug' => (is  => 'rw',
		isa => 'Bool',
		default => 1,
    );		    

=head1 METHODS

=head2 C<get>

Returns a quote for the desired product.

=cut

sub get {
    my $self = shift;
    my $url  = Finance::GDAX::URL->new;
    $url->debug($self->debug);
    $url->add('products');
    $url->add($self->product);
    $url->add('ticker');
    
    my $client = REST::Client->new;
    $client->GET($url->get);

    my $json = JSON->new;
    return $json->decode($client->responseContent);
}

__PACKAGE__->meta->make_immutable;
1;