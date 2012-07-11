package SHARYANTO::String::Util;

use 5.010;
use strict;
use warnings;

# VERSION

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(trim_blank_lines ellipsis indent);

sub trim_blank_lines {
    local $_ = shift;
    return $_ unless defined;
    s/\A(?:\n\s*)+//;
    s/(?:\n\s*){2,}\z/\n/;
    $_;
}

sub ellipsis {
    my ($str, $maxlen, $ellipsis) = @_;
    $maxlen   //= 80;
    $ellipsis //= "...";

    if (length($str) <= $maxlen) {
        return $str;
    } else {
        return substr($str, 0, $maxlen-length($ellipsis)) . $ellipsis;
    }
}

sub indent {
    my ($indent, $str) = @_;

    $str =~ s/^/$indent/mg;
    $str;
}

1;
# ABSTRACT: String utilities

=head1 FUNCTIONS

=head2 trim_blank_lines($str) => STR

Trim blank lines at the beginning and the end. Won't trim blank lines in the
middle. Blank lines include lines with only whitespaces in them.


=head2 ellipsis($str[, $maxlen, $ellipsis]) => STR

Return $str unmodified if $str's length is less than $maxlen (default 80).
Otherwise cut $str to ($maxlen - length($ellipsis)) and append $ellipsis
(default '...') at the end.

=head2 indent($indent, $str) => STR

Indent every line in $str with $indent. Example:

 indent('  ', "one\ntwo\nthree") # "  one\n  two\n  three"


=head1 FAQ

=head2 What is this?

This distribution is part of L<SHARYANTO::Utils>, a heterogenous collection of
modules that will eventually have their own proper distributions, but do not yet
because they are not ready for some reason or another. For example: alpha
quality code, code not yet properly refactored, there are still no tests and/or
documentation, I haven't decided on a proper name yet, etc.

I put it on CPAN because some of my other modules (and scripts) depend on it.
And I always like to put as much of my code in functions and modules (as opposed
to scripts) as possible, for better reusability.

You are free to use this, but beware that things might get moved around without
prior warning.

I assure you that this is not a vanity distribution :-)


=head1 SEE ALSO

L<SHARYANTO::Utils>

=cut
