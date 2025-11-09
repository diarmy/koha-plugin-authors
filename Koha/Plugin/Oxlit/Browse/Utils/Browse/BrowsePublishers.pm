package Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowsePublishers;

use strict;
use warnings;
use C4::Auth;
use C4::Context;
use Exporter qw(import);

our @EXPORT_OK = qw(listBrowseResults);

sub listBrowseResults {
    my ($searchConfig) = @_;
    
    return { results => [], total_count => 0, total_pages => 0 } unless $searchConfig;
    
    my $per_page = $searchConfig->{per_page} || 10;
    my $page = $searchConfig->{page};
    my $per_page = $searchConfig->{per_page};
    my $starts_with = $searchConfig->{starts_with};
    my $browse_by = $searchConfig->{browse_by};
    my $offset = $searchConfig->{offset} || 0;
    
    return { results => [], total_count => 0, total_pages => 0 } if $per_page <= 0;

    my $columnName = "TRIM(TRAILING ':' FROM TRIM(TRAILING '.' FROM TRIM(TRAILING ',' " .
                     "FROM TRIM(ExtractValue( metadata, '//datafield[\@tag=\"260\"]/subfield[\@code=\"b\"]' )))))";

    my $dbh = C4::Context->dbh;
    
    # Get total count for pagination
    my @countParams = ();
    my $countSql = "SELECT COUNT(DISTINCT $columnName) FROM biblio_metadata";
    if ($starts_with) {
        $countSql .= " WHERE $columnName LIKE ?";
        push @countParams, "$starts_with%";
    }
    my $count_sth = $dbh->prepare($countSql);
    $count_sth->execute(@countParams);
    my ($total_count) = $count_sth->fetchrow_array;
    
    # Get paginated authors
    my $sql = "SELECT DISTINCT $columnName as publisher FROM biblio_metadata";
    my @params = ();
    
    if ($starts_with) {
        $sql .= " WHERE $columnName LIKE ?";
        push @params, "$starts_with%";
    }

    $sql .= " ORDER BY REGEXP_REPLACE(publisher, '[^A-Za-z]', '') LIMIT ? OFFSET ?";
    push @params, $per_page, $offset;
    
    my $sth = $dbh->prepare($sql);
    $sth->execute(@params);
    
    my $results = [];
    while (my $row = $sth->fetchrow_hashref) {
        push @$results, { title => $row->{publisher} };
    }
    
    # Calculate pagination metadata
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);
    return {results => $results, total_count => $total_count, total_pages => $total_pages};
}

1;