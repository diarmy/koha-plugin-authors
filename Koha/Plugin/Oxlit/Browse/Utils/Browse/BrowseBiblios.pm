package Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseBiblios;

use strict;
use warnings;
use C4::Auth;
use C4::Context;
use Exporter qw(import);

our @EXPORT_OK = qw(listBrowseResults);

sub listBrowseResults {
    my ($searchConfig) = @_;
    my $page = $searchConfig->{page};
    my $per_page = $searchConfig->{per_page};
    my $starts_with = $searchConfig->{starts_with};
    my $browse_by = $searchConfig->{browse_by};
    my $offset = $searchConfig->{offset} || 0;

    my $browse_by_options = {
        'author'      => 'author',
        'seriestitle' => 'seriestitle',
        'title'       => 'title',
    };
    my $columnName = $browse_by_options->{$browse_by} // 'title';

    my $dbh = C4::Context->dbh;
    
    # Get total count for pagination
    my $count_sth = $dbh->prepare("SELECT COUNT(DISTINCT $columnName) FROM biblio");
    $count_sth->execute;
    my ($total_count) = $count_sth->fetchrow_array;
    
    # Get paginated authors
    my $sql = "SELECT $columnName FROM biblio WHERE $columnName IS NOT NULL";
    my @params = ();
    
    if ($starts_with) {
        $sql .= " AND $columnName LIKE ?";
        push @params, "$starts_with%";
    }

    $sql .= " GROUP BY $columnName ORDER BY $columnName LIMIT ? OFFSET ?";
    push @params, $per_page, $offset;
    
    my $sth = $dbh->prepare($sql);
    $sth->execute(@params);
    
    my $results = $sth->fetchall_arrayref({}) || [];;
    
    # Calculate pagination metadata
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);
    return {results => $results, total_count => $total_count, total_pages => $total_pages};
}