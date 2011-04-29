#!perl

use strict; use warnings;
use WWW::Oyster;
use Test::More tests => 2;

my ($oyster);

eval { $oyster = WWW::Oyster->new(); };
like($@, qr/ERROR: Missing username./);

eval { $oyster = WWW::Oyster->new('your_username'); };
like($@, qr/ERROR: Missing password./);