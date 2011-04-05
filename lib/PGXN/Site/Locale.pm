package PGXN::Site::Locale;

use 5.12.0;
use utf8;
use parent 'Locale::Maketext';
use I18N::LangTags::Detect;
use File::Spec;
use Carp;

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
    'Blog' => 'Blog',
    'FAQ' => 'FAQ',
    'Frequently Asked Questions' => 'Frequently Asked Questions',
    'Release It' => 'Release It',
    'Release it on PGXN' => 'Release it on PGXN',
    code => 'code',
    design => 'design',
    logo => 'logo',
    'Go to [_1]' => 'Go to [_1]',
    Mirroring => 'Mirroring',
    Feedback => 'Feedback',
    Extensions => 'Extensions',
    Tags => 'Tags',
    Distributions => 'Distributions',
    'PGXN Search' => 'PGXN Search',
    pgxn_summary_paragraph => 'PGXN, the PostgreSQL Extension network, is a central distribution system for open-source PostgreSQL extension libraries.',
    Founders => 'Founders',
    Patrons => 'Patrons',
    Benefactors => 'Benefactors',
    Sponsors => 'Sponsors',
    Advocates => 'Advocates',
    Supporters => 'Supporters',
    Boosters => 'Boosters',
    'Backers' => 'Backers',
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
    '<- Select a letter' => '⬅ Select a letter',
    'Pick a letter at left' => 'Pick a letter at left',
    'No user nicknames found starting with "[_1]"' => 'No user nicknames found starting with “[_1]”',

    'feedback_contact' => 'If you have any feedback about this site, its design, or how it presents information, then please send an Email to [_1].',
    'feedback_users' => 'If you have a question about an issue with a particular extension, or the content of its documentation, please contact the maintainer of that extension.',
    'feedback_forums' => 'If the feedback you want to give is not specifically about this site, then please try one of the following forums that best fits.',
    'PGXN Users' => 'PGXN Users',
    'The PGXN Users group is a great place to go with questions on creating PGXN distributions' => 'The PGXN Users group is a great place to go with questions on creating PGXN distributions',
    'PostgreSQL Mailing Lists' => 'PostgreSQL Mailing Lists',
    q{The PostgreSQL mailing lists have something for everybody: novices, users, and hackers, they're the place to go for comprehensive discussion of everything PostgreSQL.} => q{The PostgreSQL mailing lists have something for everybody: novices, users, and hackers, they’re the place to go for comprehensive discussion of everything PostgreSQL.},
    'About PGXN' => 'About PGXN',
    about_paragraph_1 => 'PGXN, the PostgreSQL Extension network, is a central distribution system for open-source PostgreSQL extension libraries. It consists of four basic parts:',
    'PGXN Manager' => 'PGXN Manager',
    pgxn_manager_bullet => 'An upload and distribution infrastructure for extension developers.',
    'PGXN API' => 'PGXN API',
    pgxn_api_bullet => 'A centralized index and API of distribution metadata.',
    'PGXN Search' => 'PGXN Search',
    pgxn_site_bullet => 'This site, for searching extensions and perusing their documentation.',
    'PGXN Client' => 'PGXN Client',
    pgxn_client_bullet => 'A command-line client for downloading, testing, and installing extensions (planned).',

    'Why?' => 'Why?',
    why_pgxn => q{One of the primary distinguishing features of <a href="http://www.postgresql.org/">PostgreSQL</a>—and perhaps the number one reason to use it instead of another DBMS—is its extensibility and the large number of database extensions already available: <a href="http://postgis.refractions.net/">PostGIS</a>, <a href="http://www.postgresql.org/docs/8.4/static/isn.html">ISN</a>, <a href="http://www.postgresql.org/docs/8.4/static/hstore.html">hstore</a>, <a href="http://pgtap.org/">pgTAP</a>, <a href="http://pgfoundry.org/projects/biopostgres/">BioPostgres</a>, <a href="http://www.joeconway.com/plr/">PL/R</a>, <a href="http://pgfoundry.org/projects/plproxy/">PL/Proxy</a>, <a href="http://code.google.com/p/golconde/">Golconde</a>, <a href="http://pgfoundry.org/projects/pgmemcache/">pgmemcache</a>, and more. Especially with the formal support for extensions <a href="http://developer.postgresql.org/pgdocs/postgres/extend-extensions.html" title="PostgreSQL 9.1.0 Documentation: “Packaging Related Objects into an Extension”">coming in 9.1.0</a>, PostgreSQL today is not merely a database, it’s an application development platform. However, many of these extensions are virtually unknown even among experienced users because they are hard to find.},
    pgxn_solved => 'PGXN solves the “hard to find” issue by providing centralized listings and searchable documentation for PostgreSQL extensions. Here you can easily search through extensions, browse their documentation, and download and install those that fill your needs. The site is structured to maximize the ability to find appropriate extensions and their documentation through search engines. Our hope is that the high visibility of PostgreSQL’s extensibility and they array of available extensions will drive PostgreSQL adoption by new users and application developers, expanding our community and ensuring another 10 years of the PostgreSQL Project.',
    q{Who's Responsible for This?} => q{Who's Responsible for This?},
    who_responsible => '<a href="http://justatheory.com/" title="Just a Theory">I am</a>. I’m David Wheeler, inveterate Perl and PostgreSQL hacker. I love the <a href="http://www.postgresql.org/docs/current/static/extend.html">extensibility of PostgreSQL</a> and have long been a fan of <a href="http://www.cpan.org/">CPAN</a>, the Perl community’s distributed collection of Perl software and documentation. But PostgreSQL’s extensibility is not well-known, and it’s difficult to find the extensions that do exist. PGXN is my attempt to solve that problem.',
    'Want to Help?' => 'Want to Help?',
    on_github => 'The source code for all the parts of PGXN are on <a href="https://github.com/pgxn/">GitHub</a>. Please feel free to fork and send merge requests!',
    backers_intro => 'All the financial backers who helped to get PGXN off the ground will be listed in perpetuity here on the “Backers” page of PGXN.org. All backers are invited to the PGXN Launch Party at <a href="http://www.pgcon.org/2011/">PGCon</a> in May, 2011.',
    founders_intro => 'Many thanks to our amazing “Founder” level backers, whose logos and links are displayed prominently here and on the PGXN home page.',
    patrons_intro => 'Our thanks to our “Patron” level contributors, whose icons and links are displayed on the PGXN home page.',
    benefactors_intro => 'Benefactors” will be listed on the PGXN home page.',

    'Releasing on PGXN' => 'Releasing on PGXN',
    q{What's allowed to be released on PGXN?} => 'What’s allowed to be released on PGXN?',
    'WTF is an "extension"?' => 'WTF is an “extension”?',
    q{What's not allowed to be released on PGXN?} => 'What’s not allowed to be released on PGXN?',
    'Who can release on PGXN?' => 'Who can release on PGXN?',
    'Who can register for PGXN?' => 'Who can register for PGXN?',
    'So how do I apply?' => 'So how do I apply?',
    'Okay, I have an account and want to release an extension. Is there a release approval process?' => 'Okay, I have an account and want to release an extension. Is there a release approval process?',
    'Great, so how do I create an extension distribution and release it?' => 'Great, so how do I create an extension distribution and release it?',
    'How is PGXN different from pgFoundry?' => 'How is PGXN different from pgFoundry?',
    'How does PGXN make it easy to distinguish the garbage from the viable extensions?' => 'How does PGXN make it easy to distinguish the garbage from the viable extensions?',
    'Is there a command-line client for installing extensions from PGXN?' => 'Is there a command-line client for installing extensions from PGXN?',
    'How will the command-line client work?' => 'How will the command-line client work?',
    'What about Windows?' => 'What about Windows?',
    'What kind of security does PGXN have?' => 'What kind of security does PGXN have?',

    'Contributing to PGXN' => 'Contributing to PGXN',
    q{Under what license is PGXN's source code distributed?} => 'Under what license is PGXN’s source code distributed?',
    'Can other people contribute to PGXN?' => 'Can other people contribute to PGXN?',
    'Who owns and runs PGXN?' => 'Who owns and runs PGXN?',
    'Where is the PGXN source code hosted?' => 'Where is the PGXN source code hosted?',
    'What language is PGXN written in?' => 'What language is PGXN written in?',
    'Is there an API?' => 'Is there an API?',

    'Mirroring PGXN' => 'Mirroring PGXN',
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

my %PATHS_FOR;

sub DESTROY {
    delete $PATHS_FOR{ ref shift };
}

sub from_file {
    my ($self, $path) = @_;
    my $class = ref $self;
    my $file = $PATHS_FOR{$class}{$path} ||= _find_file($class, $path);
    open my $fh, '<:utf8', $file or die "Cannot open $file: $!\n";
    local $/;
    <$fh>;
}

sub _find_file {
    my $class = shift;
    my @path = split m{/}, shift;
    (my $dir = __FILE__) =~ s{[.]pm$}{};
    no strict 'refs';
    foreach my $super ($class, @{$class . '::ISA'}, __PACKAGE__ . '::en') {
        my $file = File::Spec->catfile($dir, $super->language_tag, @path);
        return $file if -e $file;
    }
    croak "No file found for path " . join('/', @path);
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

=head3 C<from_file>

  my $text = $mt->from_file('foo/bar.html');

Returns the contents of a localized file. The file argument should be
specified with Unix semantics, regardless of operating system.

Localized files are created by the translators. Whereas subclasses contain
short strings that need translating, the files can contain complete documents.
All files are formatted in HTML, though they are maintained using
L<Text::MultiMarkdown> format.

For example, the L<PGXN::Site::Locale::fr> class lives in
F<PGXN/Site/Locale/fr.pm>. Localized files will live in
F<PGXN/Site/Locale/fr/>. So for the example, the localized file will be
F<PGXN/Site/Locale/fr/foo/bar.mmd>, and the HTML file (created before this
module is distributed) will be F<PGXN/Site/Locale/fr/foo/bar.mmd>.

If a file doesn't exist for the current language, C<from_file()> will fall
back on the same file path for any of its parent classes. If none has the
file, it will fall back on the English file.

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
