package WWW::Oyster;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;
use WWW::Mechanize;
use HTML::TokeParser;

=head1 NAME

WWW::Oyster - Interface to Oyster Account.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

Readonly my $LOGIN  => 'https://oyster.tfl.gov.uk/oyster/entry.do';
Readonly my $LOGOUT => 'https://oyster.tfl.gov.uk/oyster/oysterlogout.do';

=head1 DESCRIPTION

The Oyster card is a form of electronic ticketing used on public transport services within the
Greater London area of the United Kingdom. It is promoted by Transport for London and is valid
on a number of different travel systems across London including London Underground, buses, the
Docklands Light Railway(DLR),London Overground, trams,some river boat services & most National
Rail services within the London Fare Zones.

A  standard Oyster card is a blue credit-card-sized stored value card which can hold a variety
of  single tickets, period tickets and travel permits which must be added to the card prior to
travel.

=head1 CONSTRUCTOR

The constructor simply expects Oyster account username and password.

    use strict; use warnings;
    use WWW::Oyster;

    my $username = 'your_user_name';
    my $password = 'your_password';
    my $oyster = WWW::Oyster->new($username, $password);

=cut

sub new
{
    my $class    = shift;
    my $username = shift;
    my $password = shift;

    croak("ERROR: Missing username.\n") unless defined $username;
    croak("ERROR: Missing password.\n") unless defined $password;

    my $self = { username => $username,
                 password => $password,
                 browser  => new WWW::Mechanize(autocheck => 1),
               };
    bless $self, $class;
    return $self;
}

=head1 METHODS

=head2 get_account_balance()

Returns the account balance.

    use strict; use warnings;
    use WWW::Oyster;

    my $username = 'your_user_name';
    my $password = 'your_password';
    my $oyster = WWW::Oyster->new($username, $password);
    print $oyster->get_account_balance() . "\n";

=cut

sub get_account_balance
{
    my $self = shift;
    $self->{browser}->get($LOGIN);
    $self->{browser}->form_id('sign-in');
    $self->{browser}->field('j_username', $self->{username});
    $self->{browser}->field('j_password', $self->{password});
    $self->{browser}->submit();
    my $balance = _get_account_balance(\$self->{browser}->content);
    $self->{browser}->get($LOGOUT);
    return 'GBP '.$balance;
}

sub _get_account_balance
{
    my $content = shift;
    my $stream  = HTML::TokeParser->new($content);
    while((my $token = $stream->get_token))
    {
        my $ttype = shift @{$token};
        if ($ttype eq 'S')
        {
            my ($tag, $attr, $attrseq, $rawtxt) = @{$token};
            if (($tag eq 'span') && exists($attr->{class}) && ($attr->{class} eq "content"))
            {
                until (($ttype eq 'E') && ($tag eq 'span'))
                {
                    $token = $stream->get_token;
                    ($ttype, $tag, $attr, $attrseq, $rawtxt) = @{$token};
                    return $1 if (($ttype eq 'T') && ($tag =~ /Balance:\s&pound\;(.*)/))
                }
            }
        }
    }
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs/feature requests to C<bug-www-oyster at rt.cpan.org> or through the web
interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Oyster>. I will be notified,
and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Oyster

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Oyster>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Oyster>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Oyster>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Oyster/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of WWW::Oyster