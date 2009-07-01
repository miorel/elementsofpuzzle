use Test::More tests => 2;
BEGIN { use_ok('WWW::Grooveshark') };

my $gs;
ok($gs = WWW::Grooveshark->new(), 'new() returns true value');

our($api_key);

require 'config.pl';

$gs->session_start(apiKey => $api_key);
