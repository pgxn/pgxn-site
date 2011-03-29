package PGXN::Site v0.1.0;

use 5.12.0;
use utf8;

1;

=head1 Name

PGXN::Site - Maintain and serve a PGXN web site

=head1 Synopsis

  plackup pgxn_site.psgi api_url     http://api.pgxn.org/ \
                         mirror_url  http://api.pgxn.org/ \
                         errors_from oops@example.com \
                         errors_to   alerts@example.com

=head1 Description

This module provides a simple PGXN web site. All it needs is a
L<PGXN::API>-powered API to get the data it needs. Such an API can be accessed
either remotely or via the local file system.

To run your own PGXN web server, just install this module and run the included
C<pgxn_site.psgi> L<Plack> server, passing it the following options:

=over

=item C<api_url>

A URL for a L<PGXN::API>-powered API. The URL can point to either an API web
server provided by L<PGXN::API> or be a C<file:> URI pointing to the document
root managed by L<PGXN::API> on the local file system. The latter is useful if
you're serving the site and the API from the same box (or with access to the
same file system) and want it to be fast.

=item C<mirror_url>

The URL to use for links to the API server in the UI. If you're using an
C<http://> URL for the C<api_url> option, this should probably have the same
value. But if C<api_url> uses a C<file:> URL, C<mirror_url> B<must> point to
the corresponding HTTP server provided by L<PGXN::API>.

=item C<proxy_url>

If you need to access C<api_url> via a proxy server, provide the URL for that
proxy server in this option.

=item C<errors_to>

An email address to which error emails should be sent. In the event of an
internal server error, the server will send an email to this address with
diagnostic information.

=item C<errors_from>

An email address from which alert emails should be sent.

=back

=head1 Author

David E. Wheeler <david.wheeler@pgexperts.com>

=head1 Copyright and License

Copyright (c) 2011 David E. Wheeler.

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

