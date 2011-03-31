package PGXN::Site::Locale;

use 5.12.0;
use utf8;
use parent 'Locale::Maketext';
use I18N::LangTags::Detect;

# Allow unknown phrases to just pass-through.
our %Lexicon = (
#    _AUTO => 1,
    listcomma => ',',
    listand   => 'and',
    openquote => '“',
    shutquote => '”',
    in        => 'in',
    hometitle => 'PGXN: PostgreSQL Extension Network',
    'PostgreSQL Extension Network' => 'PostgreSQL Extension Network',
    'PGXN Gear' => 'PGXN Gear',
    'About' => 'About',
    'About PGXN' => 'About PGXN',
    'User' => 'User',
    'Users' => 'Users',
    'Recent' => 'Recent',
    'Recent Uploads' => 'Recent Uploads',
    'News' => 'News',
    'FAQ' => 'FAQ',
    'Frequently Asked Questions' => 'Frequently Asked Questions',
    code => 'code',
    design => 'design',
    logo => 'logo',
    'Go to [_1]' => 'Go to [_1]',
    Feedback => 'Feedback',
    Extensions => 'Extensions',
    Tags => 'Tags',
    Distributions => 'Distributions',
    'PGXN Search' => 'PGXN Search',
    pgxn_summary_paragraph => 'PGXN, the PostgreSQL Extension network, is a central distribution system for open-source PostgreSQL extension libraries.',
    Founders => 'Founders',
    Patrons => 'Patrons',
    Benefactors => 'Benefactors',
    'All Backers' => 'All Backers ➡',
    'See all our great backers!' => 'See all our great backers!',
    'Not Found' => 'Not Found',
    'Resource not found.' => 'Resource not found.',
    'Resource Not Found' => 'Resource Not Found',
    'Internal Server Error' => 'Internal Server Error',
    'Internal server error.' => 'Internal server error.',
    'Download' => 'Download',
    'Download [_1] [_2]' => 'Download [_1] [_2]',
    'Browse [_1] [_2]' => 'Browse [_1] [_2]',
    'This Release' => 'This Release',
    'Date' => 'Date',
    'Latest Stable' => 'Latest Stable',
    'Latest Testing' => 'Latest Testing',
    'Latest Unstable' => 'Latest Unstable',
    'Other Releases' => 'Other Releases',
    'Status' => 'Status',
    'stable' => 'Stable',
    'testing' => 'Testing',
    'unstable' => 'Unstable',
    'Abstract' => 'Abstract',
    'Description' => 'Description',
    'Maintainer' => 'Maintainer',
    'Maintainers' => 'Maintainers',
    'License' => 'License',
    'Resources' => 'Resources',
    'www' => 'www',
    'bugs' => 'bugs',
    'repo' => 'repo',
    'Special Files' => 'Special Files',
    'Tags' => 'Tags',
    'Other Documentation' => 'Other Documentation',
    'Released By' => 'Released By',
    'README' => 'README',
    'Documentation' => 'Documentation',
    'Nickname' => 'Nickname',
    'URL' => 'URL',
    'Email' => 'Email',
    'Twitter' => 'Twitter',
    'Browse' => 'Browse',
    'Tag: [_1]' => 'Tag: “[_1]”',
    'PGXN Search' => 'PGXN Search',
    'In the [_1] distribution' => 'In the [_1] distribution',
    'Uploaded by [_1]' => 'Uploaded by [_1]',
    'Search matched no documents.' => 'Search matched no documents.',
    'Previous results' => 'Previous results',
    'Next results' => 'Next results',
    '← Prev' => '← Prev',
    'Next →' => 'Next →',
    '[_1]-[_2] of [_3] found' => '[_1]-[_2] of [_3] found',
    'Bad Request' => 'Bad Request',
    'Bad request: Missing or invalid "[_1]" query parameter.' => 'Bad request: Missing or invalid “[_1]” query parameter.',
);

sub accept {
    shift->get_handle( I18N::LangTags::Detect->http_accept_langs(shift) );
}

sub list {
    my ($lh, $items) = @_;
    return unless @{ $items };
    return $items->[0] if @{ $items } == 1;
    my $last = pop @{ $items };
    my $comma = $lh->maketext('listcomma');
    my $ret = join  "$comma ", @$items;
    $ret .= $comma if @{ $items } > 1;
    my $and = $lh->maketext('listand');
    return "$ret $and $last";
}

sub qlist {
    my ($lh, $items) = @_;
    return unless @{ $items };
    my $open = $lh->maketext('openquote');
    my $shut = $lh->maketext('shutquote');
    return $open . $items->[0] . $shut if @{ $items } == 1;
    my $last = pop @{ $items };
    my $comma = $lh->maketext('listcomma');
    my $ret = $open . join("$shut$comma $open", @$items) . $shut;
    $ret .= $comma if @{ $items } > 1;
    my $and = $lh->maketext('listand');
    return "$ret $and $open$last$shut";
}

1;

=head1 Name

PGXN::Site::Locale - Localization for PGXN::Site

=head1 Synopsis

  use PGXN::Site::Locale;
  my $mt = PGXN::Site::Locale->accept($env->{HTTP_ACCEPT_LANGUAGE});

=head1 Description

This class provides localization support for PGXN::Site. Each locale must
create a subclass named for the locale and put its translations in the
C<%Lexicon> hash. It is further designed to support easy creation of
a handle from an HTTP_ACCEPT_LANGUAGE header.

=head1 Interface

The interface inherits from L<Locale::Maketext> and adds the following
method.

=head2 Constructor Methods

=head3 C<accept>

  my $mt = PGXN::Site::Locale->accept($env->{HTTP_ACCEPT_LANGUAGE});

Returns a PGXN::Site::Locale handle appropriate for the specified
argument, which must take the form of the HTTP_ACCEPT_LANGUAGE string
typically created in web server environments and specified in L<RFC
3282|http://tools.ietf.org/html/rfc3282>. The parsing of this header is
handled by L<I18N::LangTags::Detect>.

=head2 Instance Methods

=head3 C<list>

  # "Missing these keys: foo, bar, and baz"
  say $mt->maketext(
      'Missing these keys: [list,_1])'
      [qw(foo bar baz)],
  );

Formats a list of items. The list of items to be formatted should be passed as
an array reference. If there is only one item, it will be returned. If there
are two, they will be joined with " and ". If there are more, there will be a
comma-separated list with the final item joined on ", and ".

Note that locales can control the localization of the comma and "and" via the
C<listcomma> and C<listand> entries in their C<%Lexicon>s.

=head3 C<qlist>

  # "Missing these keys: “foo”, “bar”, and “baz”
  say $mt->maketext(
      'Missing these keys: [qlist,_1]'
      [qw(foo bar baz)],
  );

Like C<list()> but quotes each item in the list. Locales can specify the
quotation characters to be used via the C<openquote> and C<shutquote> entries
in their C<%Lexicon>s.

head1 Author

David E. Wheeler <david.wheeler@pgexperts.com>

=head1 Copyright and License

Copyright (c) 2010-2011 David E. Wheeler.

This module is free software; you can redistribute it and/or modify it under
the L<PostgreSQL License|http://www.opensource.org/licenses/postgresql>.

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

In no event shall David E. Wheeler be liable to any party for direct,
indirect, special, incidental, or consequential damages, including lost
profits, arising out of the use of this software and its documentation, even
if David E. Wheeler has been advised of the possibility of such damage.

David E. Wheeler specifically disclaims any warranties, including, but not
limited to, the implied warranties of merchantability and fitness for a
particular purpose. The software provided hereunder is on an "as is" basis,
and David E. Wheeler has no obligations to provide maintenance, support,
updates, enhancements, or modifications.

=cut
