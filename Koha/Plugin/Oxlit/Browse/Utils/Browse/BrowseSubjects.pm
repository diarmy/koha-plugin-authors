package Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseSubjects;

use strict;
use warnings;
use C4::Auth;
use C4::Context;
use Exporter qw(import);

our @EXPORT_OK = qw(listBrowseResults);

sub listBrowseResults {
    my ($searchConfig) = @_;
    
    return { results => [], total_count => 0, total_pages => 0 } unless $searchConfig;
    
    my $per_page = $searchConfig->{per_page} || 20;
    my $starts_with = $searchConfig->{starts_with};
    my $offset = $searchConfig->{offset} || 0;
    
    return { results => [], total_count => 0, total_pages => 0 } if $per_page <= 0;

    my $dbh = C4::Context->dbh;
    
    # Get total count for pagination
    my @countParams = ();
    my $countSql = "SELECT COUNT(DISTINCT subject) FROM oxlit_subjects";
    if ($starts_with) {
        $countSql .= " WHERE subject LIKE ?";
        push @countParams, "$starts_with%";
    }
    my $count_sth = $dbh->prepare($countSql);
    $count_sth->execute(@countParams);
    my ($total_count) = $count_sth->fetchrow_array;

    # Get paginated subjects
    my $sql = "SELECT DISTINCT subject FROM oxlit_subjects";
    my @params = ();
    
    if ($starts_with) {
        $sql .= " WHERE subject LIKE ?";
        push @params, "$starts_with%";
    }

    $sql .= " ORDER BY REGEXP_REPLACE(subject, '[^A-Za-z]', '') LIMIT ? OFFSET ?";
    push @params, $per_page, $offset;
    
    my $sth = $dbh->prepare($sql);
    $sth->execute(@params);
    
    my $results = [];
    while (my $row = $sth->fetchrow_hashref) {
        push @$results, { title => $row->{subject} };
    }
    
    # Calculate pagination metadata
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);
    return {results => $results, total_count => $total_count, total_pages => $total_pages};
}

1;