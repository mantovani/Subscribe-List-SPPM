package Subscribe::List::SPPM;

use warnings;
use strict;

=head1 NAME

Subscribe::List::SPPM - The great new Subscribe::List::SPPM!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Moose;
use WWW::Mechanize;

use MooseX::Types::Email qw/EmailAddress/;
use MooseX::Types::Common::String qw/SimpleStr/;

has 'mechanize' => (
    is      => 'ro',
    isa     => 'Object',
    default => sub {
        WWW::Mechanize->new(
            stack_depth => 5,
            onerror     => sub { shift->error(@_); }
        );
    }
);

has 'email'          => ( is => 'rw', isa => EmailAddress, required => 1 );
has 'fullname'       => ( is => 'rw', isa => SimpleStr,    required => 1 );
has 'passwd'         => ( is => 'rw', isa => SimpleStr,    required => 1 );
has 'confirm_passwd' => ( is => 'rw', isa => SimpleStr,    required => 1 );

has 'error' => ( is => 'rw', isa => SimpleStr );

before 'subscribe' => sub {
    my $self = shift;
    if ( $self->passwd ne $self->confirm_passwd ) {
        $self->error('The passwords are not equal');
		die $self->error;
    }

    $self->mechanize->get('http://mail.pm.org/mailman/listinfo/saopaulo-pm');
    if ( !$self->mechanize->success ) {
        return;
    }

};

sub subscribe {
    my $self = shift;

    $self->mechanize->submit_form(
        form_number => 2,
        fields      => {
            'email'    => $self->email,
            'fullname' => $self->fullname,
            'pw'       => $self->passwd,
            'pw-conf'  => $self->confirm_passwd,
        }
    );
}

after 'subscribe' => sub {
    my $self = shift;
    if ( $self->mechanize->content =~
        /Your subscription request has been received/gi )
    {
        return 1;
    }
    else {
        $self->error( $self->mechanize->content );
        return;
    }
};
111;

__END__

=head1 SYNOPSIS

API to subcribe on SPPM.

    use Subscribe::List::SPPM;

    my $slp = Subscribe::List::SPPM->new(
        email          => 'foo@foo.com.br',
        fullname       => 'My Name',
        passwd         => 'mypasswd',
        confirm_passwd => 'mypasswd',
    );  
    $slp->subscribe || die $slp->error;

    
=head1 AUTHOR

Daniel de Oliveira Mantovani, C<< <daniel.oliveira.mantovani at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-subscribe-list-sppm at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Subscribe-List-SPPM>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Subscribe::List::SPPM


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Subscribe-List-SPPM>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Subscribe-List-SPPM>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Subscribe-List-SPPM>

=item * Search CPAN

L<http://search.cpan.org/dist/Subscribe-List-SPPM/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Daniel de Oliveira Mantovani.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Subscribe::List::SPPM
