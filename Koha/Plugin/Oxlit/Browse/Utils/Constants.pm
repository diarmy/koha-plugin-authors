package Koha::Plugin::Oxlit::Browse::Utils::Constants;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(DISPLAY_BRIEF DISPLAY_FULL DISPLAY_BOTH);

use constant {
    DISPLAY_BRIEF => 1,
    DISPLAY_FULL  => 2,
    DISPLAY_BOTH  => 3,  # BRIEF | FULL
};

1;