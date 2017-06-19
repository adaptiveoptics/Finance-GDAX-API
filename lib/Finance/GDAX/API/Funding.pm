package Finance::GDAX::API::Funding;
use v5.20;
use warnings;
use Moose;
use Finance::GDAX::TypeConstraints;
use Finance::GDAX::API::Request;
use namespace::autoclean;

extends 'Finance::GDAX::API::Request';

has 'status' => (is  => 'rw',
		 isa => 'Maybe[OrderFundingStatus]',
    );

sub get {
    my $self = shift;
    my $path = '/funding';
    $path .= '?status=' . $self->status if $self->status;
    $self->path($path);
    $self->method('GET');
    return $self->send;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Finance::GDAX::API::Funding - List GDAX margin funding records

=head1 SYNOPSIS

  use Finance::GDAX::API::Funding;

  $funding = Finance::GDAX::API::Funding->new;
  $records = $funding->get;

  # To limit records based on current status
  $funding->status('settled');
  $records = $funding->get;

=head2 DESCRIPTION

Returns an array of funding records from GDAX for orders placed with a
margin profile.

From the GDAX API:

Every order placed with a margin profile that draws funding will
create a funding record.

  [
  {
    "id": "b93d26cd-7193-4c8d-bfcc-446b2fe18f71",
    "order_id": "b93d26cd-7193-4c8d-bfcc-446b2fe18f71",
    "profile_id": "d881e5a6-58eb-47cd-b8e2-8d9f2e3ec6f6",
    "amount": "1057.6519956381537500",
    "status": "settled",
    "created_at": "2017-03-17T23:46:16.663397Z",
    "currency": "USD",
    "repaid_amount": "1057.6519956381537500",
    "default_amount": "0",
    "repaid_default": false
  },
  {
    "id": "280c0a56-f2fa-4d3b-a199-92df76fff5cd",
    "order_id": "280c0a56-f2fa-4d3b-a199-92df76fff5cd",
    "profile_id": "d881e5a6-58eb-47cd-b8e2-8d9f2e3ec6f6",
    "amount": "545.2400000000000000",
    "status": "outstanding",
    "created_at": "2017-03-18T00:34:34.270484Z",
    "currency": "USD",
    "repaid_amount": "532.7580047716682500"
  },
  {
    "id": "d6ec039a-00eb-4bec-a3e1-f5c6a97c4afc",
    "order_id": "d6ec039a-00eb-4bec-a3e1-f5c6a97c4afc",
    "profile_id": "d881e5a6-58eb-47cd-b8e2-8d9f2e3ec6f6",
    "amount": "9.9999999958500000",
    "status": "outstanding",
    "created_at": "2017-03-19T23:16:11.615181Z",
    "currency": "USD",
    "repaid_amount": "0"
  }
  ]

=head1 ATTRIBUTES

=head2 C<status> $string

Limit the records returned to those records of status
$status.

Currently the GDAX API states these status must be "outstanding",
"settled" or "rejected".

=head1 METHODS

=head2 C<get>

Returns an array of funding records from GDAX.

=cut
