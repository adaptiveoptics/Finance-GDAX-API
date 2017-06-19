package Finance::GDAX::TypeConstraints;
use v5.20;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

subtype 'PositiveNum',
    as 'Num',
    where { $_ > 0 },
    message { "$_ is not a positive number" };

enum 'FundingStatus',                [qw(outstanding settled rejected)];
enum 'MarginTransferType',           [qw(deposit withdraw)];
enum 'OrderSelfTradePreventionFlag', [qw(dc co cn cb)];
enum 'OrderSide',                    [qw(buy sell)];
enum 'OrderTimeInForce',             [qw(GTC GTT IOC FOK)];
enum 'OrderType',                    [qw(limit market stop)];

__PACKAGE__->meta->make_immutable;
1;
