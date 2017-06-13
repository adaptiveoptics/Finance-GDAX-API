package Finance::GDAX::Account;
use v5.20;
use warnings;
use Moose;
use Finance::GDAX::Request;
use namespace::autoclean;

extends 'Finance::GDAX::Request';

=head1 NAME

Finance::GDAX::Account - Work with GDAX Accounts

=head1 SYNOPSIS

  use Finance::GDAX::Account;

  $account = Finance::GDAX::Account->new(key        => 'wowihefoiwhoihw',
                                         secret     => 'woihoip2hf23908hf32hf2h',
                                         passphrase => 'woiefhvbno3iurbnv9p4h49h');
  # List all accounts
  $accounts = $account->get_all;
  if ($accounts->error) {
      die 'There was an error '.$accounts->error;
  }
  foreach (@$accounts) {
      print $$_{currency}." = ".$$_{balance};
  }

  # List a single account
  $info = $account->get("wiejfwef-237897-wefhwe-wef");
  say 'Balance is ' . $$info{balance} . $$info{currency};

=head1 DESCRIPTION

Creates a GDAX account object to examine accounts.

See Finance::GDAX::Request for details on API key requirements that
need to be passed in.

The HTTP response code can be accessed via the "response_code"
attribute, and if the request resulted in a response code greater than
or equal to 400, then the "error" attribute will be set to the error
message returned by the GDAX servers.


=head1 METHODS

=head2 C<get_all>

Returns an array of hashes, with each hash representing account
details. According to the GDAX API, currently these hashes will
contain the following keys and data:

  id              Account ID
  balance         total funds in the account
  holds           funds on hold (not available for use)
  available       funds available to withdraw* or trade
  margin_enabled  [margin] true if the account belongs to margin profile
  funded_amount   [margin] amount of outstanding funds currently credited to the account
  default_amount  [margin] amount defaulted on due to not being able to pay back funding

However, this does not appear to be exactly what they are sending now.

=cut

sub get_all {
    my $self = shift;
    $self->method('GET');
    $self->path('/accounts');
    return $self->send;
}

=head2 C<get> $account_id

The get method requires passing an account id and returns a hash of
the account information. Currently the GDAX API docs say they are:

  id 	         Account ID
  balance 	 total funds in the account
  holds 	 funds on hold (not available for use)
  available      funds available to withdraw* or trade
  margin_enabled [margin] true if the account belongs to margin profile
  funded_amount  [margin] amount of outstanding funds currently credited to the account
  default_amount [margin] amount defaulted on due to not being able to pay back funding

  currency is in the hash, but not currently shown in the GDAX API table.

=cut

sub get {
    my ($self, $account_id) = @_;
    $self->method('GET');
    $self->path("/accounts/$account_id");
    return $self->send;
}

__PACKAGE__->meta->make_immutable;
1;
