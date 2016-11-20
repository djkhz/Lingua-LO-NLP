#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use feature 'unicode_strings';
use open qw/ :encoding(UTF-8) :std /;
use charnames qw/ :full lao /;
use Test::More;
use Lingua::LO::NLP;

isa_ok(Lingua::LO::NLP->new, 'Lingua::LO::NLP');

my $o = Lingua::LO::NLP->new;
is_deeply(
    [ $o->split_to_syllables(text => 'ສະບາຍດີ') ],
    [ qw/ ສະ ບາຍ ດີ / ],
    'split_to_syllables() works'
);
is($o->analyze_syllable('ດີ')->tone, 'LOW', 'analyze_syllable() works');
is($o->romanize('ສະບາຍດີ'), 'sa-bay-di', 'romanize() works');
done_testing;
