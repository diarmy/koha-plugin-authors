#!/usr/bin/perl

use strict;
use warnings;
use C4::Context;

my $dbh = C4::Context->dbh;

# --- Preparation: Create oxlit_subjects Table if it doesn't exist ---

my $create_table_sql = qq{
    CREATE TABLE IF NOT EXISTS oxlit_subjects (
        id INT AUTO_INCREMENT PRIMARY KEY,
        subject VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_subject (subject)
    )
};

$dbh->do($create_table_sql);

# --- Part 1: Extraction and Staging (The cron job part) ---
print "Starting subject extraction from biblio_metadata...\n";

my $sql_select = "SELECT metadata FROM biblio_metadata";
my $sth_select = $dbh->prepare($sql_select);
$sth_select->execute();

my %unique_subjects_to_insert;

while (my $row = $sth_select->fetchrow_arrayref) {
    my $marcxml = $row->[0];

    # Use global regex to find ALL occurrences of 650$a
    while ($marcxml =~ m|<datafield tag="650".*?<subfield code="a">(.*?)<\/subfield>.*?<\/datafield>|gs) {
        my $subject = $1;
        $subject =~ s/^\s+|\s+$//g; # Clean whitespace
        
        # Stage non-empty, unique subjects in a hash, excluding numeric values
        $unique_subjects_to_insert{$subject} = 1 if length $subject > 0 && $subject !~ /^\d+$/;
    }
}
$sth_select->finish();

print "Extracted " . scalar(keys %unique_subjects_to_insert) . " unique subjects.\n";

# --- Part 2: Batch Insertion with IGNORE (The cron job part) ---

my $sql_insert = q{
    INSERT IGNORE INTO oxlit_subjects (subject) VALUES (?)
};
my $sth_insert = $dbh->prepare($sql_insert);
my $insert_count = 0;

# Disable AutoCommit for transaction control
my $original_autocommit = $dbh->{AutoCommit};
$dbh->{AutoCommit} = 0;

# Use transactions for efficient batch insertion
foreach my $subject (keys %unique_subjects_to_insert) {
    # INSERT IGNORE handles the 'if they do not already exist' requirement
    $sth_insert->execute($subject);
    $insert_count += $sth_insert->rows();
}

# Commit all inserts
$dbh->commit();
$dbh->{AutoCommit} = $original_autocommit;
$sth_insert->finish();

print "Inserted/Updated $insert_count new subject rows in oxlit_subjects.\n";
print "---------------------------------------------------------\n";

# --- Part 3: Efficient Pagination (The direct call part) ---
print "Demonstrating fast pagination from oxlit_subjects:\n";

my $LIMIT = 50;  
my $OFFSET = 0;

my $sql_paginate = q{
    SELECT subject
    FROM oxlit_subjects
    ORDER BY subject
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