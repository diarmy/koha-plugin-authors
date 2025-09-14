package Koha::Plugin::Oxlit::Browse::Utils::MARC;

use strict;
use warnings;
use MARC::Record;
use C4::Search qw( new_record_from_zebra );

use Exporter qw(import);
our @EXPORT_OK = qw(extractBiblioFields extractBiblioFullDisplayFields getMARCRecords getMARCRecord);

=head1 NAME

Koha::Plugin::Oxlit::Browse::Utils::MARC - Utility functions for MARC record processing

=head1 SYNOPSIS

    use Koha::Plugin::Oxlit::Browse::Utils::MARC qw(extractBiblioFields getMARCRecords);

    my $biblio_data = extractBiblioFields($marc_record);
    my $records = getMARCRecords($hits, $results_per_page, $offset, $marcresults);

=cut

use constant {
    DISPLAY_BRIEF => 1,
    DISPLAY_FULL  => 2,
    DISPLAY_BOTH  => 3,  # BRIEF | FULL
};

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

sub getFieldConfiguration {
    my $field_config = {
        '020' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                isbn => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '022' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                issn => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '041' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                language => {'code' => 'a', repeatable => 1, display => DISPLAY_FULL}, 
                original_language => {'code' => 'h', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '100' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                author => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                author_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_BOTH}, 
                author_role => {'code' => 'e', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '111' => { 
            repeatable => 0,
            display => DISPLAY_FULL,
            subfields => [
                meeting_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                meeting_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                meeting_dates => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                meeting_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '240' => { 
            repeatable => 0,
            display => DISPLAY_FULL,
            subfields => [
                uniform_title => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                uniform_title_language => {'code' => 'l', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '245' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                title => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                title_remainder => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}, 
                statement_of_responsibility => {'code' => 'c', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '246' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                title_proper => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                title_proper_remainder => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '250' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                edition_statement => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '260' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                publication_location => {'code' => 'a', repeatable => 1, display => DISPLAY_BOTH}, 
                publisher => {'code' => 'b', repeatable => 1, display => DISPLAY_BOTH}, 
                publication_date => {'code' => 'c', repeatable => 1, display => DISPLAY_BOTH}
            ] 
        },
        '300' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                extent => {'code' => 'a', repeatable => 1, display => DISPLAY_BOTH}, 
                other_physical_details => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '440' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                series_title => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                series_volume_number => {'code' => 'v', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '500' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                notes => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '504' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                bibliographical_note => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '505' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                contents => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '520' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                summary => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '546' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                language_note => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '600' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                author_as_subject => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                author_as_subject_name => {'code' => 'd', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '650' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                subject => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                subject_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_FULL}, 
                subject_form_subdivision => {'code' => 'v', repeatable => 1, display => DISPLAY_FULL}, 
                subject_general_subdivision => {'code' => 'x', repeatable => 1, display => DISPLAY_BOTH}, 
                subject_chron_subdivision => {'code' => 'y', repeatable => 1, display => DISPLAY_FULL}, 
                subject_geo_subdivision => {'code' => 'z', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '700' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                added_author => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                added_author_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_BOTH},
                added_author_role => {'code' => 'e', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '710' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                added_corporate_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                added_corporate_sub_unit => {'code' => 'b', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_date => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '711' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                added_meeting_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                added_meeting_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                added_meeting_dates => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                added_meeting_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '773' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                host_item_relationship => {'code' => 'g', repeatable => 1, display => DISPLAY_FULL}, 
                host_item_title => {'code' => 't', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '774' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                constituent_titles => {'code' => 't', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '856' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                uri_host_name => {'code' => 'a', repeatable => 1, display => DISPLAY_FULL},
                uri => {'code' => 'u', repeatable => 1, display => DISPLAY_BOTH},
                uri_control_number => {'code' => 'w', repeatable => 1, display => DISPLAY_FULL}, 
                uri_link_text => {'code' => 'y', repeatable => 1, display => DISPLAY_FULL}, 
                uri_public_note => {'code' => 'z', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '911' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                document_type => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '912' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                source_type => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        }
    };

    return $field_config;
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

1;