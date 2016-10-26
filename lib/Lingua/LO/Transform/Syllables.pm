package Lingua::LO::Transform::Syllables;
use strict;
use warnings;
use 5.012000;
use utf8;
use feature 'unicode_strings';
use version 0.77; our $VERSION = version->declare('v0.0.1');
use charnames qw/ :full lao /;
use Carp;
use Unicode::Normalize qw/ NFC /;
use Class::Accessor::Fast 'antlers';
use Lingua::LO::Transform::Data ':all';

=encoding UTF-8

=head1 NAME

Lingua::LO::Transform::Syllables - Segment Lao or mixed-script text into syllables.

=head1 FUNCTION

This implements a purely regular expression based algorithm to segment Lao text into syllables, based 
on the one described in PHISSAMAY et al: I<Syllabification of Lao Script for Line Breaking>.

=cut

has text => (is => 'ro');

my $syl_re = Lingua::LO::Transform::Data::get_sylre_basic;
my $complete_syl_re = Lingua::LO::Transform::Data::get_sylre_full;

=head1 METHODS

=head2 new

C<new( text =E<gt> $text, ... )>

The constructor takes hash-style named arguments. The only one defined so far
is C<text> whose value is obviously the text to be segmented.

Note that text is passed through L<"Unicode::Normalize"/NFC> first to obtain
the Composed Normal Form. In pure Lao text, this affects only the decomposed
form of LAO VOWEL SIGN AM that will be transformed from C<U+0EB2>, C<U+0ECD> to
C<U+0EB3>.

=cut

sub new {
    my $class = shift;
    my %opts = @_;
    croak("`text' key missing or undefined") unless defined $opts{text};
    my $text = NFC( $opts{text} );
    normalize_tone_marks($text) if $opts{normalize};
    return bless { text => $text }, $class
}

=head2 get_syllables

C<get_syllables()>

Returns a list of Lao syllables found in the text passed to the constructor. If
there are any blanks, non-Lao parts etc. mixed in, they will be silently
dropped.

=cut

sub get_syllables {
    return shift->text =~ m/($complete_syl_re)/og;
}

=head2 get_fragments

C<get_fragments()>

Returns a complete segmentation of the text passed to the constructor as an
array of hashes. Each hash has two keys:

=over 4

=item C<text>: the text of the respective fragment

=item C<is_lao>: if true, the fragment is a single valid Lao syllable. If
false, it may be whitespace, non-Lao script, Lao characters that don't
constitute valid syllables - basically anything at all that's I<not> a valid
syllable.

=back

=cut

sub get_fragments {
    my $self = shift;
    my $t = $self->text;
    my @matches;
    while($t =~ /\G($complete_syl_re | .+?(?=$complete_syl_re|$) )/oxgcs) {
        unless($1 eq "\N{ZERO WIDTH SPACE}") {
            my $match = $1;
            push @matches, { text => $match, is_lao => scalar($match =~ /^$syl_re/) };
        }
    }
    return @matches
}

1;
