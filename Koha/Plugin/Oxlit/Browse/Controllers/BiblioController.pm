package Koha::Plugin::Oxlit::Browse::Controllers::BiblioController;

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

use Koha::Plugin::Oxlit::Browse::Utils::Constants qw(DISPLAY_BRIEF DISPLAY_FULL DISPLAY_BOTH);
use Koha::Plugin::Oxlit::Browse::Utils::MARC qw(extractBiblioFields getMARCRecord);
use Koha::SearchEngine::Search;
use Koha::SearchEngine::QueryBuilder;

=head1 API

=head2 Class Methods

=head3 Method to return a bibliographic record from its biblio id

=cut

sub get {
    my $c = shift->openapi->valid_input or return;
    
    # Get request params
    my $page = 1;
    my $per_page = 1;
    my $displayMode = $c->param('display');
    my @operands = ($c->param('biblio_id'));
    my @indexes = ('biblionumber,phr');
    my @sort_by = ('biblionumber_az');

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
    
    my $display_flag = ($displayMode eq 'brief') ? DISPLAY_BRIEF : DISPLAY_FULL;
    my $biblio = extractBiblioFields($record, $display_flag);

    return $c->render(
        status => 200,
        openapi => $biblio
    );
}

1;