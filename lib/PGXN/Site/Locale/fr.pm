package PGXN::Site::Locale::fr;

use 5.10.0;
use utf8;
use parent 'PGXN::Site::Locale';
our $VERSION = v0.10.1;

our %Lexicon = (
    listcomma => ',',
    listand   => 'et',
    openquote => '«',
    shutquote => '»',
    in        => 'dans',
);

1;

=head1 Name

PGXN::Site::Locale::fr - French localization for PGXN::Site

=head1 Synopsis

  use PGXN::Site::Locale;
  my $mt = PGXN::Site::Locale->accept('fr');

=head1 Description

Subclass of L<PGXN::Site::Locale> providing French localization.

=head1 Author

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
