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

=head2 extractNonRepeatMARCField

Extracts data from a non-repeating MARC field into a hash structure.

=over 4

=item C<$record> - MARC::Record object

=item C<$biblio> - Hash reference to store extracted data

=item C<$field_tag> - MARC field tag

=item C<$subfield_mapping> - Hash reference mapping keys to subfield codes

=back

=cut

sub extractNonRepeatMARCField {
    my ($record, $biblio, $field_tag, $subfield_mapping) = @_;
    
    my %field_data;
    foreach my $key (keys %$subfield_mapping) {
        $field_data{$key} = $record->subfield($field_tag, $subfield_mapping->{$key});
    }
    $biblio->{$field_tag} = \%field_data;
}

=head2 extractRepeatMARCFields

Extracts data from repeating MARC fields into an array of hash structures.

=over 4

=item C<$record> - MARC::Record object

=item C<$biblio> - Hash reference to store extracted data

=item C<$field_tag> - MARC field tag

=item C<$subfield_mapping> - Hash reference mapping keys to subfield codes

=back

=cut

sub extractRepeatMARCFields {
    my ($record, $biblio, $field_tag, $subfield_mapping) = @_;
    
    my @fields = $record->field($field_tag);
    foreach my $field (@fields) {
        my %field_data;
        foreach my $key (keys %$subfield_mapping) {
            my $subfield_code = $subfield_mapping->{$key}->{code};
            my $repeat = $subfield_mapping->{$key}->{repeat};
            
            if ($repeat) {
                my @subfield_values = $field->subfield($subfield_code);
                $field_data{$key} = \@subfield_values;
            } else {
                $field_data{$key} = $field->subfield($subfield_code);
            }
        }
        push @{ $biblio->{$field_tag} }, \%field_data;
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
    my ($record) = @_;
    
    my $biblio = {};

    # Extract author (100)
    extractNonRepeatMARCField($record, $biblio, '100', {
        author => 'a',
        author_dates => 'd'
    });

    # Extract title (245)
    extractNonRepeatMARCField($record, $biblio, '245', {
        title => 'a',
        title_remainder => 'b',
        statement_of_responsibility => 'c'
    });

    extractRepeatMARCFields($record, $biblio, '246', {
        title_proper => { code => 'a', repeat => 0 },
        title_proper_remainder => { code => 'b', repeat => 0 }
    });

    # Extract edition statements (250)
    extractRepeatMARCFields($record, $biblio, '250', {
        edition_statement => { code => 'a', repeat => 0 }
    });

    # Extract publication statements (260)
    extractRepeatMARCFields($record, $biblio, '260', {
        publication_location => { code => 'a', repeat => 1 },
        publisher => { code => 'b', repeat => 1 },
        publication_date => { code => 'c', repeat => 1 }
    });

    # Extract physical description (300)
    extractNonRepeatMARCField($record, $biblio, '300', {
        extent => { code => 'a', repeat => 1 },
        other_physical_details => { code => 'b', repeat => 0 }
    });

    # Extract series statement (440)
    extractRepeatMARCFields($record, $biblio, '440', {
        series_title => { code => 'a', repeat => 0 },
        series_volume_number => { code => 'v', repeat => 0 }
    });

    # Extract subject added entry - personal name (600)
    extractRepeatMARCFields($record, $biblio, '600', {
        author_as_subject => { code => 'a', repeat => 0 }
    });

    # Extract subject added entry - topical term (650)
    extractRepeatMARCFields($record, $biblio, '650', {
        subject => { code => 'a', repeat => 0 },
        subject_general_subdivision => { code => 'x', repeat => 0 }
    });

    # Extract added entry - personal name (700)
    extractRepeatMARCFields($record, $biblio, '700', {
        added_author => { code => 'a', repeat => 0 },
        added_author_dates => { code => 'd', repeat => 0 }
    });

    # Extract host item entry (773)
    extractRepeatMARCFields($record, $biblio, '773', {
        host_item_relationship => { code => 'g', repeat => 0 },
        host_item_title => { code => 't', repeat => 0 }
    });

    # Extract electronic location and access (856)
    extractRepeatMARCFields($record, $biblio, '856', {
        uri => { code => 'u', repeat => 0 }
    });

    # Extract local field (911)
    extractNonRepeatMARCField($record, $biblio, '911', {
        document_type => 'a'
    });
    
    return $biblio;
}

=head2 extractBiblioFullDisplayFields

Extracts all bibliographic fields from a MARC record for full display and returns them as a hash reference.
This function extends extractBiblioFields with additional fields.

=over 4

=item C<$record> - MARC::Record object to extract fields from

=back

Returns a hash reference containing the extracted bibliographic data.

=cut

sub extractBiblioFullDisplayFields {
    my ($record) = @_;
    
    my $biblio = extractBiblioFields($record);
    
    $biblio->{language} = $record->subfield('041', 'a') || '';
    $biblio->{original_language} = $record->subfield('041', 'h') || '';
    $biblio->{isbn} = $record->subfield('020', 'a') || '';
    $biblio->{issn} = $record->subfield('022', 'a') || '';
    $biblio->{author_role} = $record->subfield('100', 'e') || '';
    $biblio->{meeting_name} = $record->subfield('111', 'a') || '';
    $biblio->{meeting_location} = $record->subfield('111', 'c') || '';
    $biblio->{meeting_dates} = $record->subfield('111', 'd') || '';
    $biblio->{meeting_section_number} = $record->subfield('111', 'n') || '';
    $biblio->{uniform_title} = $record->subfield('240', 'a') || '';
    $biblio->{uniform_title_language} = $record->subfield('240', 'l') || '';
    $biblio->{parallel_title} = $record->subfield('246', 'a') || '';
    $biblio->{notes} = join(' ', $record->subfield('500', 'a')) || '';
    $biblio->{bibliographical_note} = $record->subfield('504', 'a') || '';
    $biblio->{contents} = $record->subfield('505', 'a') || '';
    $biblio->{summary} = $record->subfield('520', 'a') || '';
    $biblio->{language_note} = $record->subfield('546', 'a') || '';
    $biblio->{author_as_subject_name} = join(' ', $record->subfield('600', 'a')) || '';
    $biblio->{author_as_subject_dates} = join(' ', $record->subfield('600', 'd')) || '';
    $biblio->{subject_dates} = join(' ', $record->subfield('650', 'd')) || '';
    $biblio->{subject_form_subdivision} = $record->subfield('650', 'v') || '';
    $biblio->{subject_chron_subdivision} = $record->subfield('650', 'y') || '';
    $biblio->{subject_geo_subdivision} = $record->subfield('650', 'z') || '';
    $biblio->{added_author_role} = $record->subfield('700', 'e') || '';
    $biblio->{added_corporate_name} = $record->subfield('710', 'a') || '';
    $biblio->{added_corporate_sub_unit} = $record->subfield('710', 'b') || '';
    $biblio->{added_corporate_location} = $record->subfield('710', 'c') || '';
    $biblio->{added_corporate_date} = $record->subfield('710', 'd') || '';
    $biblio->{added_corporate_section_number} = $record->subfield('710', 'n') || '';
    $biblio->{added_meeting_name} = $record->subfield('711', 'a') || '';
    $biblio->{added_meeting_location} = $record->subfield('711', 'c') || '';
    $biblio->{added_meeting_dates} = $record->subfield('711', 'd') || '';
    $biblio->{added_meeting_section_number} = $record->subfield('711', 'n') || '';
    $biblio->{constituent_titles} = $record->subfield('774', 't') || '';
    $biblio->{uri_host_name} = $record->subfield('856', 'a') || '';
    $biblio->{uri_control_number} = $record->subfield('856', 'w') || '';
    $biblio->{uri_link_text} = $record->subfield('856', 'y') || '';
    $biblio->{uri_public_note} = $record->subfield('856', 'z') || '';
    $biblio->{source_type} = $record->subfield('912', 'a') || '';

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

1;