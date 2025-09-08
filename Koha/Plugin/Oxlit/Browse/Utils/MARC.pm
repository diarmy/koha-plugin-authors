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

=head3 extractBiblioFields

Extracts bibliographic fields from a MARC record and returns them as a hash reference.

=over 4

=item C<$record> - MARC::Record object to extract fields from

=back

Returns a hash reference containing the extracted bibliographic data.

=cut

sub extractBiblioFields {
    my ($record) = @_;
    
    my $biblio = {};
    $biblio->{author} = $record->subfield('100', 'a') || '';
    $biblio->{author_dates} = $record->subfield('100', 'd') || '';
    $biblio->{title} = $record->subfield('245', 'a') || '';
    $biblio->{title_remainder} = $record->subfield('245', 'b') || '';
    $biblio->{statement_of_responsibility} = $record->subfield('245', 'c') || '';
    $biblio->{title_proper} = $record->subfield('246', 'a') || '';
    $biblio->{title_proper_remainder} = $record->subfield('246', 'b') || '';
    $biblio->{edition_statement} = $record->subfield('250', 'a') || '';
    $biblio->{publication_location} = $record->subfield('260', 'a') || '';
    $biblio->{publisher} = $record->subfield('260', 'b') || '';
    $biblio->{publication_date} = $record->subfield('260', 'c') || '';
    $biblio->{extent} = $record->subfield('300', 'a') || '';
    $biblio->{other_physical_details} = $record->subfield('300', 'b') || '';
    $biblio->{series_title} = $record->subfield('440', 'a') || '';
    $biblio->{series_volume_number} = $record->subfield('440', 'v') || '';
    $biblio->{author_as_subject} = $record->subfield('600', 'a') || '';
    $biblio->{subject} = $record->subfield('650', 'a') || '';
    $biblio->{subject_general_subdivision} = $record->subfield('650', 'x') || '';
    $biblio->{added_author} = $record->subfield('700', 'a') || '';
    $biblio->{added_author_dates} = $record->subfield('700', 'd') || '';
    $biblio->{host_item_relationship} = $record->subfield('773', 'g') || '';
    $biblio->{host_item_title} = $record->subfield('773', 't') || '';
    $biblio->{uri} = $record->subfield('856', 'u') || '';
    $biblio->{document_type} = $record->subfield('911', 'a') || '';
    
    return $biblio;
}

sub extractBiblioFullDisplayFields {
    my ($record) = @_;
    
    my $biblio = {};
    $biblio->{document_type} = $record->subfield('911', 'a') || '';
    $biblio->{title} = $record->subfield('245', 'a') || '';
    $biblio->{title_remainder} = $record->subfield('245', 'b') || '';
    $biblio->{statement_of_responsibility} = $record->subfield('245', 'c') || '';
    $biblio->{uniform_title} = $record->subfield('240', 'a') || '';
    $biblio->{uniform_title_language} = $record->subfield('240', 'l') || '';
    $biblio->{parallel_title} = $record->subfield('246', 'a') || '';
    $biblio->{author_name} = $record->subfield('100', 'a') || '';
    $biblio->{author_dates} = $record->subfield('100', 'd') || '';
    $biblio->{author_role} = $record->subfield('100', 'e') || '';
    $biblio->{added_author_name} = $record->subfield('700', 'a') || '';
    $biblio->{added_author_dates} = $record->subfield('700', 'd') || '';
    $biblio->{added_author_role} = $record->subfield('700', 'e') || '';
    $biblio->{added_corporate_name} = $record->subfield('710', 'a') || '';
    $biblio->{added_corporate_sub_unit} = $record->subfield('710', 'b') || '';
    $biblio->{added_corporate_location} = $record->subfield('710', 'c') || '';
    $biblio->{added_corporate_date} = $record->subfield('710', 'd') || '';
    $biblio->{added_corporate_section_number} = $record->subfield('710', 'n') || '';
    $biblio->{meeting_name} = $record->subfield('111', 'a') || '';
    $biblio->{meeting_location} = $record->subfield('111', 'c') || '';
    $biblio->{meeting_dates} = $record->subfield('111', 'd') || '';
    $biblio->{meeting_section_number} = $record->subfield('111', 'n') || '';
    $biblio->{added_meeting_name} = $record->subfield('711', 'a') || '';
    $biblio->{added_meeting_location} = $record->subfield('711', 'c') || '';
    $biblio->{added_meeting_dates} = $record->subfield('711', 'd') || '';
    $biblio->{added_meeting_section_number} = $record->subfield('711', 'n') || '';
    $biblio->{edition_statement} = $record->subfield('250', 'a') || '';
    $biblio->{publication} = $record->subfield('260', 'a') || '';
    $biblio->{publisher} = $record->subfield('260', 'b') || '';
    $biblio->{publication_dates} = $record->subfield('260', 'c') || '';
    $biblio->{pages} = $record->subfield('300', 'a') || '';
    $biblio->{other_page_details} = $record->subfield('300', 'b') || '';
    $biblio->{language} = $record->subfield('041', 'a') || '';
    $biblio->{original_language} = $record->subfield('041', 'h') || '';
    $biblio->{isbn} = $record->subfield('020', 'a') || '';
    $biblio->{issn} = $record->subfield('022', 'a') || '';
    $biblio->{notes} = join(' ', $record->subfield('500', 'a')) || '';
    $biblio->{bibliographical_note} = $record->subfield('504', 'a') || '';
    $biblio->{contents} = $record->subfield('505', 'a') || '';
    $biblio->{summary} = $record->subfield('520', 'a') || '';
    $biblio->{language_note} = $record->subfield('546', 'a') || '';
    $biblio->{author_as_subject_name} = join(' ', $record->subfield('600', 'a')) || '';
    $biblio->{author_as_subject_dates} = join(' ', $record->subfield('600', 'd')) || '';
    $biblio->{subject} = join(' ', $record->subfield('650', 'a')) || '';
    $biblio->{subject_dates} = join(' ', $record->subfield('650', 'd')) || '';
    $biblio->{subject_form_subdivision} = $record->subfield('650', 'v') || '';
    $biblio->{subject_dates_gen_subdiv} = $record->subfield('650', 'x') || '';
    $biblio->{subject_chron_subdivision} = $record->subfield('650', 'y') || '';
    $biblio->{subject_geo_subdivision} = $record->subfield('650', 'z') || '';
    $biblio->{constituent_titles} = $record->subfield('774', 't') || '';
    $biblio->{source_title} = $record->subfield('773', 't') || '';
    $biblio->{source_relationship} = $record->subfield('773', 'g') || '';
    $biblio->{source_type} = $record->subfield('912', 'a') || '';
    $biblio->{series} = $record->subfield('440', 'a') || '';
    $biblio->{series_volume} = $record->subfield('440', 'v') || '';
    $biblio->{uri_host_name} = $record->subfield('856', 'a') || '';
    $biblio->{uri} = $record->subfield('856', 'u') || '';
    $biblio->{uri_control_number} = $record->subfield('856', 'w') || '';
    $biblio->{uri_link_text} = $record->subfield('856', 'y') || '';
    $biblio->{uri_public_note} = $record->subfield('856', 'z') || '';

    return $biblio;
}

=head3 getMARCRecords

Retrieves and processes MARC records from search results.

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

=head3 getMARCRecord

Extracts and decodes a MARC record from search results

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