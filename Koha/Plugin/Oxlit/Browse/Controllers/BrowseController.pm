package Koha::Plugin::Oxlit::Browse::Controllers::BrowseController;

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
use Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseBiblios qw(listBrowseResults);
use Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowsePublishers qw(listBrowseResults);
use Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseSubjects qw(listBrowseResults);
use Koha::Plugin::Oxlit::Browse::Utils::Browse::BrowseAuthorsAsSubject qw(listBrowseResults);

=head1 API

=head2 Class Methods

=head3 Method to return a list of publishers

=cut

sub getBrowseResults {
    my ($self, $searchConfig) = @_;
    my $browse_by = $searchConfig->{browse_by};
    
    # Map browse_by values to package names
    my %package_map = (
        'author'   => 'BrowseBiblios',
        'authorassubject'    => 'BrowseAuthorsAsSubject',
        'publisher' => 'BrowsePublishers',
        'seriestitle'   => 'BrowseBiblios',
        'subject'  => 'BrowseSubjects',
        'title'    => 'BrowseBiblios',
    );
    
    my $package = $package_map{$browse_by};
    return unless $package;  # handle unknown browse_by values
    
    # Dynamically call the method
    my $package_name = "Koha::Plugin::Oxlit::Browse::Utils::Browse::${package}";
    my $method_name = "${package_name}::listBrowseResults";
    
    if (my $method_ref = $self->can($method_name)) {
        return $method_ref->($searchConfig);
    } else {
        die "Method $method_name does not exist";
    }
}

sub list {
    my $self = shift;
    my $c = $self->openapi->valid_input or return;

    # Get request params
    my $page = $c->param('page') || 1;
    my $per_page = $c->param('per_page') || 20;
    my $starts_with = $c->param('starts_with') || '';
    my $browse_by = $c->param('browse_by');
    my @operands = ('a');
    my @indexes = ('kw');
    my @sort_by = ();
    my $offset = ($page - 1) * $per_page;

    my ($browse_results) = $self->getBrowseResults({
        page => $page,
        per_page => $per_page,
        offset => $offset,
        starts_with => $starts_with,
        browse_by => $browse_by
    });

    return $c->render(
        status => 200,
        openapi => {
            results => $browse_results->{results},
            pagination => {
                total_count => $browse_results->{total_count},
                total_pages => $browse_results->{total_pages},
                current_page => $page,
                per_page => $per_page
            }
        }
    );
}

1;