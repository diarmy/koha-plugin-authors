package Koha::Plugin::Oxlit::Browse::Utils::MARC;

use strict;
use warnings;
use MARC::Record;
use C4::Search qw( new_record_from_zebra );
use Koha::Plugin::Oxlit::Browse::Utils::Constants qw(DISPLAY_BRIEF DISPLAY_FULL DISPLAY_BOTH);
use Koha::Plugin::Oxlit::Browse::Utils::FieldConfiguration qw(getFieldConfiguration);

use Exporter qw(import);
our @EXPORT_OK = qw(extractBiblioFields extractBiblioFullDisplayFields getMARCRecords getMARCRecord isOPACSuppressed);

=head1 NAME

Koha::Plugin::Oxlit::Browse::Utils::MARC - Utility functions for MARC record processing

=head1 SYNOPSIS

    use Koha::Plugin::Oxlit::Browse::Utils::MARC qw(extractBiblioFields getMARCRecords);

    my $biblio_data = extractBiblioFields($marc_record);
    my $records = getMARCRecords($hits, $results_per_page, $offset, $marcresults);

=cut

=head2 _extractFieldData

Extracts subfield data from a MARC field based on configuration settings.

This is a private helper function that processes a MARC field and extracts
specified subfields according to their configuration. It handles both 
repeatable and non-repeatable subfields appropriately.

=over 4

=item C<$field> - MARC::Field object to extract data from

=item C<@subfieldSettings> - Array of key-value pairs where keys are field names 
and values are hash references containing subfield configuration with the following structure:
    - code: The MARC subfield code (e.g., 'a', 'b', 'c')
    - repeatable: Boolean indicating if the subfield can appear multiple times

=item C<$display_mode> - Display mode

=back

Returns a hash reference containing the extracted subfield data. For repeatable
subfields, the value will be an array reference containing all occurrences.
For non-repeatable subfields, the value will be a scalar.

=cut

sub _extractFieldData {
    my ($field, $display_mode, @subfieldSettings) = @_;
    
    my %field_data;
    while (my ($key, $config) = splice(@subfieldSettings, 0, 2)) {
        next if $display_mode == DISPLAY_BRIEF && $config->{display} == DISPLAY_FULL;

        my $subfield_code = $config->{code};
        my $is_repeatable = $config->{repeatable};
        
        if ($is_repeatable) {
            my @subfield_values = $field->subfield($subfield_code);
            $field_data{$key} = \@subfield_values;
        } else {
            $field_data{$key} = $field->subfield($subfield_code);
        }
    }
    return \%field_data;
}

=head2 extractNonRepeatMARCField

Extracts data from a non-repeating MARC field into a hash structure.

=over 4

=item C<$record> - MARC::Record object

=item C<$biblio> - Hash reference to store extracted data

=item C<$field_tag> - MARC field tag

=item C<$subfield_mapping> - Hash reference mapping keys to subfield codes

=item C<$display_mode> - Display mode 

=back

=cut

sub extractNonRepeatMARCField {
    my ($record, $biblio, $field_tag, $display_mode, @subfieldSettings) = @_;
    
    my $field = $record->field($field_tag);
    return unless defined $field;
    
    $biblio->{$field_tag} = _extractFieldData($field, $display_mode, @subfieldSettings);
}

=head2 extractRepeatMARCFields

Extracts data from repeating MARC fields into an array of hash structures.

=over 4

=item C<$record> - MARC::Record object

=item C<$biblio> - Hash reference to store extracted data

=item C<$field_tag> - MARC field tag

=item C<$subfield_mapping> - Hash reference mapping keys to subfield codes

=item C<$display_mode> - Display mode

=back

=cut

sub extractRepeatMARCFields {
    my ($record, $biblio, $field_tag, $display_mode, @subfieldSettings) = @_;
    
    my @fields = $record->field($field_tag);
    foreach my $field (@fields) {
        push @{ $biblio->{$field_tag} }, _extractFieldData($field, $display_mode, @subfieldSettings);
    }
}

=head2 extractBiblioFields

Extracts bibliographic fields from a MARC record and returns them as a hash reference.

=over 4

=item C<$record> - MARC::Record object to extract fields from

=back

Returns a hash reference containing the extracted bibliographic data.

=cut

sub extractBiblioFields {
    my ($record, $display_mode) = @_;
    
    my $biblio = {};
    my $field_config = getFieldConfiguration();

    foreach my $marc_field (keys %$field_config) {
        my $config = $field_config->{$marc_field};
        
        # Skip fields based on display mode
        next if $display_mode == DISPLAY_BRIEF && $config->{display} == DISPLAY_FULL;

        # Determine if this is a repeatable field based on configuration
        if ($config->{repeatable}) {
            extractRepeatMARCFields($record, $biblio, $marc_field, $display_mode, @{$config->{subfields}});
        } else {
            extractNonRepeatMARCField($record, $biblio, $marc_field, $display_mode, @{$config->{subfields}});
        }
    }   
    
    return $biblio;
}

=head2 getMARCRecords

Retrieves and processes MARC records from search results.

=over 4

=item C<$hits> - Total number of search hits

=item C<$results_per_page> - Number of results to process per page

=item C<$offset> - Starting offset for processing

=item C<$marcresults> - Array reference containing raw MARC data

=back

Returns an array reference of MARC::Record objects.

=cut

sub getMARCRecords {
    my ( $hits, $results_per_page, $offset, $marcresults ) = @_;
    my @newresults;
    my $marcrecord;

    my $times;
    if ( $hits && $offset + $results_per_page <= $hits ) {
        $times = $offset + $results_per_page;
    } else {
        $times = $hits // 0;
    }

    for ( my $i = $offset ; $i <= $times - 1 ; $i++ ) {
        $marcrecord = new_record_from_zebra(
                'biblioserver',
                $marcresults->[$i]
            );

        if ( !defined $marcrecord ) {
            warn "ERROR DECODING RECORD - $@: " . $marcresults->[$i];
            next;
        }
         
        push( @newresults, $marcrecord );
    }

    return \@newresults;
}

=head2 getMARCRecord

Extracts and decodes a MARC record from search results.

=over 4

=item C<$marcresults> - Array reference containing raw MARC data

=back

Returns a MARC::Record object or undef on error.

=cut

sub getMARCRecord {
    my ( $marcresults ) = @_;

    # Validate input
    if ( !defined $marcresults || !@$marcresults ) {
        warn "No MARC results provided to getMARCRecord";
        return;
    }

    my $marcrecord = new_record_from_zebra(
        'biblioserver',
        $marcresults->[0]
    );

    if ( !defined $marcrecord ) {
        warn "ERROR DECODING RECORD - $@: " . $marcresults->[0];
        return;
    }

    return $marcrecord;
}

=head2 isOPACSuppressed

Checks if a MARC record is suppressed from OPAC display.

A record is considered suppressed if the 942$n field is set to "1".

=over 4

=item C<$record> - MARC::Record object to check

=back

Returns 1 if the record is suppressed, 0 otherwise.

=cut

sub isOPACSuppressed {
    my ($record) = @_;
    
    return 0 unless defined $record;
    
    my $field_942 = $record->field('942');
    return 0 unless $field_942;
    
    my $opac_suppression = $field_942->subfield('n');
    return (defined $opac_suppression && $opac_suppression eq '1') ? 1 : 0;
}

1;