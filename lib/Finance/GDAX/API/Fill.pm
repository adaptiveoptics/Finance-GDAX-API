package Finance::GDAX::API::Fill;
use v5.20;
use warnings;
use Moose;
use Finance::GDAX::API::Request;
use namespace::autoclean;

extends 'Finance::GDAX::API::Request';

has 'order_id' => (is  => 'rw',
		   isa => 'Maybe[Str]',
    );
has 'product_id' => (is  => 'rw',
		     isa => 'Maybe[Str]',
    );

sub get {
    my $self = shift;
    my @qparams;
    my $path = '/fills';
    push @qparams, 'order_id='   . $self->order_id   if $self->order_id;
    push @qparams, 'product_id=' . $self->product_id if $self->product_id;
    if (scalar @qparams) {
	$path .= '?' . join('&', @qparams);
    }
    $self->method('GET');
    $self->path($path);
    return $self->send;
}

__PACKAGE__->meta->make_immutable;
1;


=head1 NAME

Finance::GDAX::API::Fill - Retrieve GDAX fill orders

=head1 SYNOPSIS

  use Finance::GDAX::API::Fill;

  # Get all fills for a given $orderid
  $fills = Finance::GDAX::API::Fill->new(order_id => $orderid)->get;
  
  # Get all fills for a given $productid
  $gdax_fills = Finance::GDAX::API::Fill->new;
  $gdax_fills->product_id($productid);
  $fills = $gdax_fills->get;

  # Or get all of them
  $gdax_fills = Finance::GDAX::API::Fill->new;
  $fills = $gdax_fills->get;

=head2 DESCRIPTION

Returns an array of recent fills to orders.

The ATTRIBUTES may be set to limit what is returned.

The returned array according to current API docs should look like
this:

  [
    {
        "trade_id": 74,
        "product_id": "BTC-USD",
        "price": "10.00",
        "size": "0.01",
        "order_id": "d50ec984-77a8-460a-b958-66f114b0de9b",
        "created_at": "2014-11-07T22:19:28.578544Z",
        "liquidity": "T",
        "fee": "0.00025",
        "settled": true,
        "side": "buy"
    }
  ]

Also from the API docs:

=head3 Settlement and Fees

=over

Fees are recorded in two stages. Immediately after the matching engine
completes a match, the fill is inserted into our datastore. Once the
fill is recorded, a settlement process will settle the fill and credit
both trading counterparties.

The fee field indicates the fees charged for this individual fill.

=back

=head3 Liquidity

=over

The liquidity field indicates if the fill was the result of a
liquidity provider or liquidity taker. M indicates Maker and T
indicates Taker.

=back

=head1 ATTRIBUTES

=head2 C<order_id>

An order ID as generated by the GDAX exchange.

=head2 C<product_id>

A GDAX exchange product id.

=head1 METHODS

=head2 C<get>

Returns an array of "recent" fills. This array can be limited by
specifying an order_id attribute or a product_id attribute.

See the DESCRIPTION for an example return structure.

Although the API supports pagination, this API currently does not
support it, and only the first page of the results will be returned
(as sorted by largest trade_id)

=cut

=head1 AUTHOR

Mark Rushing <mark@orbislumen.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Home Grown Systems, SPC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

