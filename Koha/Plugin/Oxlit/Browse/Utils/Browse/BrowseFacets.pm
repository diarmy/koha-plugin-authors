package Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseFacets;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(listBrowseResults);

use C4::Auth;
use C4::Context;
use C4::Languages   qw( getlanguage );
use URI::Escape;
use POSIX qw(ceil floor);
use JSON qw( decode_json encode_json );
use CGI qw('-no_undef_params' -utf8 );

use Koha::Plugin::Oxlit::Browse::Utils::Facets qw(getRecords);
use Koha::SearchEngine::Search;
use Koha::SearchEngine::QueryBuilder;
use Koha::SearchFields;
use Koha::SearchFilters;

sub listBrowseResults {
    my ($searchConfig) = @_;
    my $page = $searchConfig->{page};
    my $per_page = $searchConfig->{per_page};
    my $starts_with = $searchConfig->{starts_with};
    my $browse_by = $searchConfig->{browse_by};
    my $offset = $searchConfig->{offset} || 0;
    my @operands = ('a');
    my @indexes = ('kw');
    my @sort_by = ();

    use Data::Dumper;
    print STDERR Dumper($searchConfig);
    
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
    my $browse_by_options = {
        'authorassubject'    => 'Subject-name-personal:0',
        'publisher' => 'pb:0',
        'subject'   => 'su-to:0',
    };
    my $idx = $browse_by_options->{$browse_by} // 'pb:0';
    my $facet_config = {idx => $idx, sep => '--', max_count => 10000};

    # Carry out the search
    eval {
        my $itemtypes = { map { $_->{itemtype} => $_ } @{ Koha::ItemTypes->search_with_localization->unblessed } };
        ( $error, $results_hashref, $facets ) = getRecords(
            $query,            $facet_config, \@sort_by, [$server],
            $per_page, $offset,       undef,     $itemtypes,
            $query_type,       $scan
        );
    };

    my $facets = $facets->[0]->{facets} // [];
    
    # Filter facets based on starts_with parameter
    if ($starts_with ne '') {
        $facets = [ grep { $_->{facet_label_value} =~ /^\Q$starts_with\E/i } @$facets ];
    }

    # Only use facets for this page.
    my $end_index = ($offset + $per_page - 1) > $#$facets ? $#$facets : ($offset + $per_page - 1);
    my $paginated_facets = [ 
        map { 
            { 
                title => $_->{title}, 
                biblio_count => $_->{facet_count} 
            } 
        } @$facets[$offset .. $end_index] 
    ];

    my $total_count = scalar(@$facets);
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);

    return {results => $paginated_facets, total_count => $total_count, total_pages => $total_pages};
}

1;