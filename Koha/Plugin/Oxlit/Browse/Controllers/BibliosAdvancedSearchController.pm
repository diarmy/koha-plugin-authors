package Koha::Plugin::Oxlit::Browse::Controllers::BibliosAdvancedSearchController;

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
use C4::Context;
use C4::Search      qw( new_record_from_zebra );
use C4::Languages   qw( getlanguage );
use URI::Escape;
use POSIX qw(ceil floor);
use JSON qw( decode_json encode_json );
use CGI qw('-no_undef_params' -utf8 );

use Koha::SearchEngine::Search;
use Koha::SearchEngine::QueryBuilder;
use Koha::SearchFields;
use Koha::SearchFilters;

=head3 example

Returns the string 'example'

=cut

sub getMARCRecords {
    my ( $hits, $results_per_page, $offset, $marcresults ) = @_;
    my @newresults;
    my $marcrecord;

    my $times;    # Times is which record to process up to
    if ( $hits && $offset + $results_per_page <= $hits ) {
        $times = $offset + $results_per_page;
    } else {
        $times = $hits // 0;    # If less hits than results_per_page+offset we go to the end
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

=head1 API

=head2 Class Methods

=head3 Method to return a list of bibliographic records

=cut

sub list {
    my $c = shift->openapi->valid_input or return;
    
    # Get request params
    my $page = $c->param('page') || 1;
    my $per_page = $c->param('per_page') || 20;
    my $operands = $c->every_param('q[]');
    my @operands = @{$operands};
    my @indexes = map { s/_/,/g; $_ } $c->every_param('search_in[]');
    my $sort_by = $c->every_param('sort_by') ? $c->every_param('sort_by') : ();
    my @sort_by = @{$sort_by};

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

    # Calculate pagination metadata
    my $total_count = $results_hashref->{$server}->{"hits"} // 0;
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);

    # Retrieve results
    my @records =  @{ getMARCRecords($total_count, $per_page, $offset, $results_hashref->{$server}->{"RECORDS"}) };

    foreach my $record (@records) {
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

        push @$biblios, $biblio;
    }

    return $c->render(
        status => 200,
        openapi => {
            biblios => $biblios,
            pagination => {
                total_count => $total_count,
                total_pages => $total_pages,
                current_page => $page,
                per_page => $per_page
            }
        }
    );
}

1;