package Koha::Plugin::Oxlit::Browse::Utils::MARC;

use strict;
use warnings;
use MARC::Record;
use C4::Search qw( new_record_from_zebra );

use Exporter qw(import);
our @EXPORT_OK = qw(extractBiblioFields getMARCRecords);

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