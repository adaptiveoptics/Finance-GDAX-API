requires 'ExtUtils::MakeMaker' => '6.17';
#requires 'DBIx::Class' => '0.082810';
#requires 'DBIx::Class::Schema::Loader' => '0.07042';
#requires 'DBD::Pg' => '3.4.2';
#requires 'MooseX::Singleton' => '0.29';
#requires 'Try::Tiny' => '0.22';
#requires 'Config::Tiny' => '2.23';
#requires 'DateTime::Format::Pg' => '0.16010';
requires 'namespace::autoclean' => '0.20';
requires 'Moose' => '2.12';
requires 'Digest::SHA' => '5.93';
requires 'MIME::Base64' => '3.15';
requires 'REST::Client' => '273';
requires 'LWP::Protocol::https' => '6.06';
on test => sub {
    requires 'Test::More' => '0.88';
    requires 'Test::Exception' => '0.35';
}
