package Koha::Plugin::Oxlit::Browse::AuthorsController;

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

=head1 API

=head2 Class Methods

=head3 Method to return a list of authors

=cut

sub list {
    my $c = shift->openapi->valid_input or return;
    
    # Get pagination parameters
    my $page = $c->param('page') || 1;
    my $per_page = $c->param('per_page') || 20;
    
    # Calculate offset
    my $offset = ($page - 1) * $per_page;
    
    my $dbh = C4::Context->dbh;
    
    # Get total count for pagination
    my $count_sth = $dbh->prepare("SELECT COUNT(DISTINCT author) FROM biblio");
    $count_sth->execute;
    my ($total_count) = $count_sth->fetchrow_array;
    
    # Get paginated authors
    my $sth = $dbh->prepare("SELECT author FROM biblio WHERE author IS NOT NULL GROUP BY author ORDER BY author LIMIT ? OFFSET ?");
    $sth->execute($per_page, $offset);
    
    my $authors = $sth->fetchall_arrayref({});
    
    unless ($authors) {
        return $c->render( status => 404, openapi => { error => "No authors found." } );
    }
    
    # Calculate pagination metadata
    my $total_pages = int(($total_count + $per_page - 1) / $per_page);
    
    return $c->render(
        status => 200,
        openapi => {
            authors => $authors,
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