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

subtype 'OrderSelfTradePreventionFlag',
    as 'Str',
    where { enum([qw(dc co cn cb)]) },
    message { "$_ is not a valid self trade prevention flag" };

subtype 'OrderSide',
    as 'Str',
    where { enum([qw(buy sell)]) },
    message { "$_ is not a valid order side" };

subtype 'OrderTimeInForce',
    as 'Str',
    where { enum([qw(GTC GTT IOC FOK)]) },
    message { "$_ is not a valid time in force" };

subtype 'OrderType',
    as 'Str',
    where { enum([qw(limit market stop)]) },
    message { "$_ is not a valid order type" };

__PACKAGE__->meta->make_immutable;
1;
