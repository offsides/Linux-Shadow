package Linux::Shadow;

use 5.016003;
use strict;
use warnings;
use feature 'state';
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Linux::Shadow ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
    SHADOW
    getspnam
    getspent
    setspent
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
    getspnam
    getspent
    setspent
);

our $VERSION = '0.02';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Linux::Shadow::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
        no strict 'refs';
        *$AUTOLOAD = sub { $val };
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Linux::Shadow', $VERSION);

# Preloaded methods go here.

# Track if getspent() was called, so endspent() can be called on termination.
state $spent = 0;

# Return the shadow entry for the specified user.
sub getspnam {

    my ($name) = @_;

    if (!$name) {
        return;
    }

    return _getspnam($name);

}

# Return the next shadow entry
sub getspent {

    $spent++;
    return _getspent();

}

# If getspent was called, call endspent to free up the memory structures.
END {
    endspent() if $spent;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Linux::Shadow - Perl extension for accessing the shadow files using the
standard libc shadow routines.

=head1 SYNOPSIS

  use Linux::Shadow;
  ($name, $passwd, $lstchg, $min, $max, $warn, $inact, $expire, $flag) = getspnam('user');
  ($name, $passwd, $lstchg, $min, $max, $warn, $inact, $expire, $flag) = getspent();
  setspent();
  
=head1 EXPORT

=over

=item getspnam($)

Return the shadow entry of the listed user as an array.  If the user doesn't
exist, or an error occurrs, returns an empty array.

=item getspent()

Return the shadow entry of the next user in the shadow file starting with the
first entry the first time getspent() is called.  Returns and empty array once
the end of the shadow file is reached or an error occurs.

=item setspent()

Resets the pointer in the shadow file to the beginning.

=back

=head2 Exportable constants

  SHADOW - the path of the system shadow file

This is not exported by default.  You can get both this constant and the
exported functions by using the ':all' tag.

=head1 Shadow Entry

The shadow entry is an array of 9 items as follows:

=over

=item name

The user login name.

=item passwd

The user's encrypted password.

=item lstchg

The number of days since Jan 1, 1970 password was last changed.

=item min

The number of days before which password may not be changed.

=item max

The number of days after which password must be changed.

=item warn

The number of days before password is to expire that user is warned of pending
password expiration.

=item inact

The number of days after password expires that account is considered inactive and disabled.

=item expire

The number of days since Jan 1, 1970 when account will be disabled.

=item flag

This field is reserved for future use.

=back

=head1 FILES

These functions rely on the system shadow file, which is usually /etc/shadow.

=head1 CAVEATS

Access to the shadow file requires root privileges, or possibly membership in
the shadow group if it exists (this is OS/distribution-specific).  Calling
getspnam or getspent without as a non- root user will return nothing.

=head1 SEE ALSO

L<shadow(3)>, L<getspnam(3)>

=head1 AUTHOR

Joshua Megerman, E<lt>josh@honorablemenschen.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by Joshua Megerman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
