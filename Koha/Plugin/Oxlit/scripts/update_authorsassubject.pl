#!/usr/bin/perl

use strict;
use warnings;
use C4::Context;

my $dbh = C4::Context->dbh;

# --- Preparation: Create oxlit_authorsassubject Table if it doesn't exist ---

my $create_table_sql = qq{
    CREATE TABLE IF NOT EXISTS oxlit_authorsassubject (
        id INT AUTO_INCREMENT PRIMARY KEY,
        author VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_author (author)
    )
};

$dbh->do($create_table_sql);

# --- Part 1: Extraction and Staging (The cron job part) ---
print "Starting author extraction from biblio_metadata...\n";

my $sql_select = "SELECT metadata FROM biblio_metadata";
my $sth_select = $dbh->prepare($sql_select);
$sth_select->execute();

my %unique_authors_to_insert;

while (my $row = $sth_select->fetchrow_arrayref) {
    my $marcxml = $row->[0];

    # Use global regex to find ALL occurrences of 600$a and 600$d. Concatenate them if they
    # are in the same datafield.
    while ($marcxml =~ m|<datafield tag="600".*?>(.*?)<\/datafield>|gs) {
        my $datafield_content = $1;
        my @subfields;

        # Extract all $a and $d subfields from this datafield
        while ($datafield_content =~ m|<subfield code="([ad])">(.*?)<\/subfield>|gs) {
            my $subfield_value = $2;
            $subfield_value =~ s/^\s+|\s+$//g; # Clean whitespace
            push @subfields, $subfield_value if length $subfield_value > 0;
        }
        
        # Concatenate all subfields with " " separator if we have any
        if (@subfields) {
            my $author = join(" ", @subfields);
            # Stage non-empty, unique authors in a hash, excluding numeric values
            $unique_authors_to_insert{$author} = 1 if length $author > 0 && $author !~ /^\d+$/;
        }
    }
}
$sth_select->finish();

print "Extracted " . scalar(keys %unique_authors_to_insert) . " unique authors.\n";

# --- Part 2: Batch Insertion with IGNORE (The cron job part) ---

my $sql_insert = q{
    INSERT IGNORE INTO oxlit_authorsassubject (author) VALUES (?)
};
my $sth_insert = $dbh->prepare($sql_insert);
my $insert_count = 0;

# Disable AutoCommit for transaction control
my $original_autocommit = $dbh->{AutoCommit};
$dbh->{AutoCommit} = 0;

# Use transactions for efficient batch insertion
eval {
    foreach my $author (keys %unique_authors_to_insert) {
        # INSERT IGNORE handles the 'if they do not already exist' requirement
        $sth_insert->execute($author);
        $insert_count += $sth_insert->rows();
    }

    # Commit all inserts
    $dbh->commit();
};
if ($@) {
    $dbh->rollback();
    die "Transaction failed: $@";
};

$dbh->{AutoCommit} = $original_autocommit;
$sth_insert->finish();

print "Inserted/Updated $insert_count new author rows in oxlit_authorsassubject.\n";
print "---------------------------------------------------------\n";

# --- Part 3: Efficient Pagination (The direct call part) ---
print "Demonstrating fast pagination from oxlit_authorsassubject:\n";

my $LIMIT = 50;  
my $OFFSET = 0;

my $sql_paginate = q{
    SELECT author
    FROM oxlit_authorsassubject
    ORDER BY author
    LIMIT ? OFFSET ?
};
my $sth_paginate = $dbh->prepare($sql_paginate);
$sth_paginate->execute($LIMIT, $OFFSET);

my $page_num = int($OFFSET / $LIMIT) + 1;
print "Subjects (Page $page_num, Limit $LIMIT):\n";

while (my @row = $sth_paginate->fetchrow_array) {
    print "$row[0]\n";
}

$sth_paginate->finish();
$dbh->disconnect();