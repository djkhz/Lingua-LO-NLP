#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use feature 'unicode_strings';
use open qw/ :encoding(UTF-8) :std /;
use charnames qw/ :full lao /;
use Test::More;
use Lingua::LO::Transform::Analyze;

my %tests = (
    # Generated syllables from some list or other
    'ກວກ' => { consonant => 'ກ', end_consonant => 'ກ', tone => 'LOW', vowel => 'Xວ', vowel_length => 'long' },
    'ກວງ' => { consonant => 'ກ', end_consonant => 'ງ', tone => 'LOW', vowel => 'Xວ', vowel_length => 'long' },
    #'ກວະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xະ', vowel_length => 'short' },
    #'ກວັດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'HIGH_STOP', vowel => 'Xັ', vowel_length => 'short' },
    #'ກວຽດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'LOW', vowel => 'Xຽ', vowel_length => 'long' },
    #'ກວ່ວຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xວ', vowel_length => 'long' },
    #'ກວ່ະ' => { consonant => 'ກ', tone => 'HIGH_STOP', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xະ', vowel_length => 'short' },
    #'ກວ້ອງ' => { consonant => 'ກ', end_consonant => 'ງ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xອ', vowel_length => 'long' },
    #'ກວ໊າ' => { consonant => 'ກ', tone_mark => "\N{LAO TONE MAI TI}", vowel => 'Xາ', vowel_length => 'long' },
    #'ກວໍ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xໍ', vowel_length => 'long' },
    #'ກວໍ້' => { consonant => 'ກ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xໍ', vowel_length => 'long' },
    #'ກວໍ໊' => { consonant => 'ກ', tone_mark => "\N{LAO TONE MAI TI}", vowel => 'Xໍ', vowel_length => 'long' },
    'ກ່ວງ' => { consonant => 'ກ', end_consonant => 'ງ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xວ', vowel_length => 'long' },
    'ກ່າ' => { consonant => 'ກ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xາ', vowel_length => 'long' },
    'ກ່າຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xາ', vowel_length => 'long' },
    'ກໍ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xໍ', vowel_length => 'long' },
    'ກໍ່' => { consonant => 'ກ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xໍ', vowel_length => 'long' },
    'ກໍ໋' => { consonant => 'ກ', tone_mark => "\N{LAO TONE MAI CATAWA}", vowel => 'Xໍ', vowel_length => 'long' },
    #'ສວວມ' => { consonant => 'ສ', end_consonant => 'ມ', tone => 'LOW_RISING', vowel => 'Xວ', vowel_length => 'long' },
    'ແໜ' => { consonant => 'ໜ', tone => 'LOW_RISING', vowel => 'ແX', vowel_length => 'long' },
    'ແຫນ' => { consonant => 'ຫ', end_consonant => 'ນ', tone => 'LOW_RISING', vowel => 'ແX', vowel_length => 'long' },
    'ຫາມ' => { consonant => 'ຫ', end_consonant => 'ມ', tone => 'LOW_RISING', vowel => 'Xາ', vowel_length => 'long' },
    #'ເກວວ' => { consonant => 'ກ', end_consonant => 'ວ', tone => 'LOW', vowel => 'ເX', vowel_length => 'long' },
    'ເກິ່ຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'HIGH_STOP', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'ເXິ', vowel_length => 'short' },

    # Constructed syllables with simple vowels
    'ກະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xະ', vowel_length => 'short' },
    'ກາ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xາ', vowel_length => 'long' },

    'ກິ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xິ', vowel_length => 'short' },
    'ກີ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xີ', vowel_length => 'long' },

    'ກຶ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xຶ', vowel_length => 'short' },
    'ກື' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xື', vowel_length => 'long' },

    'ກຸ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xຸ', vowel_length => 'short' },
    'ກູ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xູ', vowel_length => 'long' },

    'ເກະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ເXະ', vowel_length => 'short' },
    'ເກັນ' => { consonant => 'ກ', end_consonant => 'ນ', tone => 'HIGH_STOP', vowel => 'ເXັ', vowel_length => 'short' },
    'ເກ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ເX', vowel_length => 'long' },

    'ແກະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ແXະ', vowel_length => 'short' },
    'ແກັດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'HIGH_STOP', vowel => 'ແXັ', vowel_length => 'short' },
    'ແກ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ແX', vowel_length => 'long' },

    'ໂກະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ໂXະ', vowel_length => 'short' },
    'ໂກ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ໂX', vowel_length => 'long' },

    'ກັນ' => { consonant => 'ກ', end_consonant => 'ນ', tone => 'HIGH_STOP', vowel => 'Xັ', vowel_length => 'short' },
    'ກົດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'HIGH_STOP', vowel => 'Xົ', vowel_length => 'short' },

    'ເກາະ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ເXາ', vowel_length => 'short' },
    'ກໍ' => { consonant => 'ກ', tone => 'LOW', vowel => 'Xໍ', vowel_length => 'long' },
    'ກອດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'LOW', vowel => 'Xອ', vowel_length => 'long' },

    'ເກິ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ເXິ', vowel_length => 'short' },
    'ເກີ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ເXີ', vowel_length => 'long' },

    ###' Diphthongs
    'ເກັຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'HIGH_STOP', vowel => 'ເXັ', vowel_length => 'short' },
    'ເກຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'LOW', vowel => 'ເX', vowel_length => 'long' },

    'ເກົາ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ເXົາ', vowel_length => 'short' },

    'ເກຶອ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'ເXຶອ', vowel_length => 'short' },
    'ເກືອ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ເXືອ', vowel_length => 'long' },

    'ກວດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'LOW', vowel => 'Xວ', vowel_length => 'long' },
    'ກັວກ' => { consonant => 'ກ', end_consonant => 'ກ', syllable => 'ກັວກ', tone => 'HIGH_STOP', vowel => 'Xັວ', vowel_length => 'short' },

    'ໄກ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ໄX', vowel_length => 'long' },
    'ໃນ' => { consonant => 'ນ', tone => 'HIGH', vowel => 'ໃX', vowel_length => 'long' },
    'ກາຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'LOW', vowel => 'Xາ', vowel_length => 'long' },
    'ກັຍ' => { consonant => 'ກ', end_consonant => 'ຍ', tone => 'HIGH_STOP', vowel => 'Xັ', vowel_length => 'short' },

    'ແປຽ' => { consonant => 'ປ', tone => 'HIGH_STOP', vowel => 'ແXຽ', vowel_length => 'short' },
    'ກໍາ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xໍາ', vowel_length => 'short' },  # /am/, decomposed
    'ກຳ' => { consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xຳ', vowel_length => 'short' },  # /am/, composed

    'ກຽດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'LOW', vowel => 'Xຽ', vowel_length => 'long' },
    'ຈື່ງ' => { consonant => 'ຈ', end_consonant => 'ງ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xື', vowel_length => 'long' },
    'ຊັນ' => { consonant => 'ຊ', end_consonant => 'ນ', tone => 'MID_STOP', vowel => 'Xັ', vowel_length => 'short' },
    'ຊົ່ວ' => { consonant => 'ຊ', end_consonant => 'ວ', tone => 'MID_STOP', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xົ', vowel_length => 'short' },
    'ຍະ' => { consonant => 'ຍ', tone => 'MID_STOP', vowel => 'Xະ', vowel_length => 'short' },
    'ດີ' => { consonant => 'ດ', tone => 'LOW', vowel => 'Xີ', vowel_length => 'long' },
    'ດ້ວຍ' => { consonant => 'ດ', end_consonant => 'ຍ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xວ', vowel_length => 'long' },
    'ຕິ' => { consonant => 'ຕ', tone => 'HIGH_STOP', vowel => 'Xິ', vowel_length => 'short' },
    'ຕົນ' => { consonant => 'ຕ', end_consonant => 'ນ', tone => 'HIGH_STOP', vowel => 'Xົ', vowel_length => 'short' },
    'ຕ້ອງ' => { consonant => 'ຕ', end_consonant => 'ງ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xອ', vowel_length => 'long' },
    'ຕໍ່' => { consonant => 'ຕ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xໍ', vowel_length => 'long' },
    'ທາງ' => { consonant => 'ທ', end_consonant => 'ງ', tone => 'HIGH', vowel => 'Xາ', vowel_length => 'long' },
    'ທຳ' => { consonant => 'ທ', tone => 'MID_STOP', vowel => 'Xຳ', vowel_length => 'short' },
    'ນຸດ' => { consonant => 'ນ', end_consonant => 'ດ', tone => 'MID_STOP', vowel => 'Xຸ', vowel_length => 'short' },
    'ນ້ອງ' => { consonant => 'ນ', end_consonant => 'ງ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xອ', vowel_length => 'long' },
    'ປະ' => { consonant => 'ປ', tone => 'HIGH_STOP', vowel => 'Xະ', vowel_length => 'short' },
    'ປັດ' => { consonant => 'ປ', end_consonant => 'ດ', tone => 'HIGH_STOP', vowel => 'Xັ', vowel_length => 'short' },
    'ພາບ' => { consonant => 'ພ', end_consonant => 'ບ', tone => 'HIGH', vowel => 'Xາ', vowel_length => 'long' },
    'ພີ່' => { consonant => 'ພ', tone => 'MID', tone_mark => "\N{LAO TONE MAI EK}", vowel => 'Xີ', vowel_length => 'long' },
    'ພຶດ' => { consonant => 'ພ', end_consonant => 'ດ', tone => 'MID_STOP', vowel => 'Xຶ', vowel_length => 'short' },
    'ມະ' => { consonant => 'ມ', tone => 'MID_STOP', vowel => 'Xະ', vowel_length => 'short' },
    'ມາ' => { consonant => 'ມ', tone => 'HIGH', vowel => 'Xາ', vowel_length => 'long' },
    'ມີ' => { consonant => 'ມ', tone => 'HIGH', vowel => 'Xີ', vowel_length => 'long' },
    'ສະ' => { consonant => 'ສ', tone => 'HIGH_STOP', vowel => 'Xະ', vowel_length => 'short' },
    'ສັກ' => { consonant => 'ສ', end_consonant => 'ກ', tone => 'HIGH_STOP', vowel => 'Xັ', vowel_length => 'short' },
    'ສຳ' => { consonant => 'ສ', tone => 'HIGH_STOP', vowel => 'Xຳ', vowel_length => 'short' },
    'ສິດ' => { consonant => 'ສ', end_consonant => 'ດ', tone => 'HIGH_STOP', vowel => 'Xິ', vowel_length => 'short' },
    'ຮູ້' => { consonant => 'ຮ', tone => 'HIGH_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xູ', vowel_length => 'long' },
    'ເກີດ' => { consonant => 'ກ', end_consonant => 'ດ', tone => 'LOW', vowel => 'ເXີ', vowel_length => 'long' },
    #'ເສລີ' => { consonant => 'ສ', tone => 'LOW_RISING', vowel => 'ເXີ', vowel_length => 'long' },
    'ເໝີ' => { consonant => 'ໝ', tone => 'LOW_RISING', vowel => 'ເXີ', vowel_length => 'long' },
    'ແລະ' => { consonant => 'ລ', tone => 'MID_STOP', vowel => 'ແXະ', vowel_length => 'short' },
    'ໂນ' => { consonant => 'ນ', tone => 'HIGH', vowel => 'ໂX', vowel_length => 'long' },
    'ໃກ' => { consonant => 'ກ', tone => 'LOW', vowel => 'ໃX', vowel_length => 'long' },
    'ໜ້າ' => { consonant => 'ໜ', tone => 'MID_FALLING', tone_mark => "\N{LAO TONE MAI THO}", vowel => 'Xາ', vowel_length => 'long' },
);
for my $analysis (values %tests) {
    s/X/\N{DOTTED CIRCLE}/ for values %$analysis;
}

isa_ok(Lingua::LO::Transform::Analyze->new('ສະ'), 'Lingua::LO::Transform::Analyze');
for my $syllable (sort keys %tests) {
    my %c = %{ Lingua::LO::Transform::Analyze->new($syllable) };
    #print "'$syllable' => " . print_struct(%c) . "\n";
    #next;
    delete $c{parse};
    delete $c{$_} for grep { not defined $c{$_} } keys %c;
    $tests{$syllable}{syllable} = $syllable;    # trivial, doesn't need to be mentioned above
    is_deeply(\%c, $tests{$syllable}, "`$syllable' analyzed correctly")
}
done_testing;

# Just for adding new tests
sub print_struct {
    my %s = @_;
    return sprintf('{ %s },',
        join(", ",
            map {
                sprintf "%s => %s", $_, ref($s{$_}) ? print_struct(%{$s{$_}}) : "'$s{$_}'"
            }
            grep {
                defined $s{$_} and !/^parse$/
            } sort keys %s
        )
    );
}

