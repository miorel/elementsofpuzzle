use Test::More tests => 2;
BEGIN { use_ok('App::PDBRun') };

cmp_ok(App::PDBRun->run('echo', '2ili.pdb'), '==', 0);
