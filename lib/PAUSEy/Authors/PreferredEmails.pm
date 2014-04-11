package PAUSEy::Authors::PreferredEmails;

# ABSTRACT: Determine a CPAN author's preferred email address, if defined

use strict;
use warnings;

use utf8;
use open ':encoding(utf8)';
use autodie 'system';

use Sub::Exporter::Progressive -setup => {
    exports => [ qw{ for_pause_id from_address } ],
};

use YAML::Tiny;
use Path::Tiny;
use File::ShareDir::ProjectDistDir;

use aliased 'Email::Address' => 'eAddr';

sub for_pause_id {
    #body ...
}

sub from_address {
    #body ...
}

!!42;
__END__

use Encode qw(decode_utf8);
use autobox::Core;

use IPC::System::Simple ( ); # explict dep for autodie system

# our "global" email mapping... map
has _contributor_emails => (
    is       => 'lazy',
    isa      => HashRef[Str],
    init_arg => undef,

    builder => sub {

        my $mapping = YAML::Tiny->read(
                file(
                    dist_dir('PAUSEy-Authors-PreferredEmails'),
                    'author-emails.yaml',
                ),
            )
            ->[0]
            ;

        ### $mapping

        my $_map_it = sub {
            my ($canonical, @alternates) = @_;
            #@alternates = map { decode_utf8($_) } @alternates;
            return ( map { $_ => $canonical } @alternates );
        };

        $mapping = {
            map { $_map_it->($_ => $mapping->{$_}->flatten) }
            #map { decode_utf8($_)                           }
            $mapping->keys->flatten
        };

        ### $mapping
        return $mapping;
    },
);


!!42;
__END__

L<MetaCPAN|http://metacpan.org> will attempt to match a contributor address
back to a PAUSE account.  However, it (currently) can only do that if the
contributor's email address is their C<PAUSEID@cpan.org> address.  There are
two mechanisms for helping to resolve this, if your commits are not using this
address.

This package contains a YAML file containing a mapping of C<@cpan.org> author
addresses; this list is consulted while building the contributors list, and
can be used to replace a non-cpan.org address with one.

To add to or modify this mapping, please feel free to fork, add your alternate
email addresses to C<share/author-emails.yaml>, and submit a pull-request for
inclusion.  It'll be merged and released; as various authors update their set
of installed modules and cut new releases, the mapping will appear.

=head1 SYNOPSIS

    use PAUSEy::Authors::PreferredEmails;
    

=head1 DESCRIPTION

=cut

