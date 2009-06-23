use Test::More tests => 4;
BEGIN { use_ok('WWW::SPOJ::User') };

can_ok('WWW::SPOJ::User', qw(name username country institution email motto));

ok(!WWW::SPOJ::User->new('!@&*^'), 'new() returns false with bad username');

SKIP: {
    my $conn_ok;
    eval 'use Net::Config qw(%NetConfig); $conn_ok = $NetConfig{test_hosts}';
    skip 'Net::Config needed for network-related tests', 1 if $@;
    skip 'No network connection', 1 unless $conn_ok;
    
    ok(WWW::SPOJ::User->new('john_jones'), 'new() test');
}
