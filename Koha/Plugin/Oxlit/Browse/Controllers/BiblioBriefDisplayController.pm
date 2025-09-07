package Koha::Plugin::Oxlit::Browse::Controllers::BiblioBriefDisplayController;

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use Modern::Perl;

use Mojo::Base 'Mojolicious::Controller';

use C4::Auth;
use C4::Search      qw( new_record_from_zebra );
use C4::Languages   qw( getlanguage );
use CGI qw('-no_undef_params' -utf8 );

use Koha::SearchEngine::Search;
use Koha::SearchEngine::QueryBuilder;

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

=head1 API

=head2 Class Methods

=head3 Method to return a bibliographic record from its biblio id

=cut

sub get {
    my $c = shift->openapi->valid_input or return;
    
    # Get request params
    my $page = 1;
    my $per_page = 1;
    my @operands = ($c->param('biblio_id'));
    my @indexes = ('biblionumber');
    my @sort_by = ();

    # Calculate offset
    my $offset = ($page - 1) * $per_page;
    
    my $biblios = [];
    
    # Define some variables for the search query
    my ( $error, $query, $simple_query, $query_cgi, $query_desc, $limit, $limit_cgi, $limit_desc, $query_type );
    my $cgi = CGI->new;
    my $lang = C4::Languages::getlanguage($cgi);
    my @limits = ();
    my @operators = ();
    my $weight_search = 0;
    my $whole_record = 0;
    my $scan = 0;

    my $builder  = Koha::SearchEngine::QueryBuilder->new( { index => $Koha::SearchEngine::BIBLIOS_INDEX } );
    my $searcher = Koha::SearchEngine::Search->new( { index => $Koha::SearchEngine::BIBLIOS_INDEX } );
    
    # Build the search query
    (
        $error,      $query, $simple_query, $query_cgi,
        $query_desc, $limit, $limit_cgi,    $limit_desc,
        $query_type
    ) = $builder->build_query_compat(
        \@operators, \@operands, \@indexes, \@limits,
        \@sort_by,   $scan,      $lang,     { weighted_fields => $weight_search, whole_record => $whole_record }
    );

    
    my $server = 'biblioserver';
    my $facets;
    my $results_hashref;
    
    # Carry out the search
    eval {
        my $itemtypes = { map { $_->{itemtype} => $_ } @{ Koha::ItemTypes->search_with_localization->unblessed } };
        ( $error, $results_hashref, $facets ) = $searcher->search_compat(
            $query,            $simple_query, \@sort_by, [$server],
            $per_page, $offset,       undef,     $itemtypes,
            $query_type,       $scan
        );
    };

    # Retrieve record
    my $record =  getMARCRecord($results_hashref->{$server}->{"RECORDS"});
    
    if (!defined $record) {
        return $c->render(
            status => 404,
            openapi => { error => "Record not found" }
        );
    }

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

    return $c->render(
        status => 200,
        openapi => $biblio
    );
}

1;