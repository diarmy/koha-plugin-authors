package Koha::Plugin::Oxlit::Browse;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

use C4::Context;
use Mojo::JSON qw(decode_json);

our $VERSION = "{VERSION}";

our $metadata = {
    name            => 'Oxlit Browse Plugin',
    author          => 'Diarmuid',
    date_authored   => '2025-08-07',
    minimum_version => '24.11.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'A series of APIs to browse bibliographic data.',
    namespace       => 'oxlit',
};

sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual $self
    my $self = $class->SUPER::new($args);

    return $self;
}

sub api_routes {
    my ( $self, $args ) = @_;

    my $spec_dir = $self->mbf_dir();

    my $schema = JSON::Validator::Schema::OpenAPIv2->new;
    my $spec = $schema->resolve($spec_dir . '/openapi.yaml');

    return $self->_convert_refs_to_absolute($spec->data->{'paths'}, 'file://' . $spec_dir . '/');
}

sub api_namespace {
    my ( $self ) = @_;

    return 'oxlit';
}

# Mandatory even if does nothing
sub install {
    my ( $self, $args ) = @_;

    my $dbh = C4::Context->dbh;
    
    # Check if the documenttype column already exists
    my $sth = $dbh->prepare("SHOW COLUMNS FROM biblio LIKE 'documenttype'");
    $sth->execute();
    
    # Add the column if it doesn't exist
    if ($sth->rows == 0) {
        $dbh->do("ALTER TABLE biblio ADD COLUMN documenttype LONGTEXT DEFAULT NULL COMMENT 'Document type classification added by Oxlit Browse Plugin'");
        
        # Log the change
        $self->_version_check();
    }

    # Update marc_subfield_structure to point 911$a to biblio.documenttype
    my $update_sth = $dbh->prepare("
        UPDATE marc_subfield_structure 
        SET kohafield = 'biblio.documenttype' 
        WHERE tagfield = '911' AND tagsubfield = 'a'
    ");
    $update_sth->execute();
    
    # Log the change
    $self->_version_check();
    
    return 1;
}

# Mandatory even if does nothing
sub upgrade {
    my ( $self, $args ) = @_;

    return 1;
}

# Mandatory even if does nothing
sub uninstall {
    my ( $self, $args ) = @_;

    return 1;
}

sub _convert_refs_to_absolute {
    my ( $self, $hashref, $path_prefix ) = @_;

    foreach my $key (keys %{ $hashref }) {
        if ($key eq '$ref') {
            if ($hashref->{$key} =~ /^(\.\/)?openapi/) {
                $hashref->{$key} = $path_prefix . $hashref->{$key};
            }
        } elsif (ref $hashref->{$key} eq 'HASH' ) {
            $hashref->{$key} = $self->_convert_refs_to_absolute($hashref->{$key}, $path_prefix);
        } elsif (ref($hashref->{$key}) eq 'ARRAY') {
            $hashref->{$key} = $self->_convert_array_refs_to_absolute($hashref->{$key}, $path_prefix);
        }
    }
    return $hashref;
}

sub _convert_array_refs_to_absolute {
    my ( $self, $arrayref, $path_prefix ) = @_;

    my @res;
    foreach my $item (@{ $arrayref }) {
        if (ref($item) eq 'HASH') {
            $item = $self->_convert_refs_to_absolute($item, $path_prefix);
        } elsif (ref($item) eq 'ARRAY') {
            $item = $self->_convert_array_refs_to_absolute($item, $path_prefix);
        }
        push @res, $item;
    }
    return \@res;
}

1;