package Koha::Plugin::Oxlit::Browse::Controllers::BibliosBasicSearchController;

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

use Koha::Plugin::Oxlit::Browse::Utils::Constants qw(DISPLAY_BRIEF);
use Koha::Plugin::Oxlit::Browse::Utils::MARC qw(extractBiblioFields getMARCRecords isOPACSuppressed);
use Koha::SearchEngine::Search;
use Koha::SearchEngine::QueryBuilder;
use Koha::SearchFields;
use Koha::SearchFilters;

=head1 API

=head2 Class Methods

=head3 Method to return a list of bibliographic records

=cut

sub list {
    my $c = shift->openapi->valid_input or return;
    
    # Get pagination parameters
    my $page = $c->param('page') || 1;
    my $per_page = $c->param('per_page') || 20;
    my $search_in = $c->param('search_in') || '';
    $search_in =~ s/_/,/g if $search_in;  # Convert underscores to commas
    my $q = $c->param('q') || '';

    # Calculate offset
    my $offset = ($page - 1) * $per_page;
    my $biblios = [];
    
    # Define some variables for the search query
    my ( $error, $query, $simple_query, $query_cgi, $query_desc, $limit, $limit_cgi, $limit_desc, $query_type );
    my $cgi = CGI->new;
    my $lang = C4::Languages::getlanguage($cgi);
    my @limits = ();
    my @operands = ($q);
    my @operators = ();
    my @indexes = ($search_in);
    my @sort_by = $c->param('sort_by') ? ($c->param('sort_by')) : ();
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

    # Retrieve results
    my @records =  @{ getMARCRecords($total_count, $per_page, $offset, $results_hashref->{$server}->{"RECORDS"}) };

    foreach my $record (@records) {
        next if isOPACSuppressed($record);
        
        my $biblio = extractBiblioFields($record, DISPLAY_BRIEF);
        push @$biblios, $biblio;
    }

    # Recalculate counts after filtering out suppressed records
    my $updated_total_count = scalar @$biblios;
    my $total_pages = $updated_total_count > 0 ? int(($updated_total_count + $per_page - 1) / $per_page) : 0;
    
    return $c->render(
        status => 200,
        openapi => {
            biblios => $biblios,
            pagination => {
                total_count => $updated_total_count,
                total_pages => $total_pages,
                current_page => $page,
                per_page => $per_page
            }
        }
    );
}

1;