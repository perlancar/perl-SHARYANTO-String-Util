package SHARYANTO::String::Util;

use 5.010;
use strict;
use warnings;

# VERSION

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(trim_blank_lines ellipsis indent linenum pad);

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
    my ($indent, $str, $opts) = @_;
    $opts //= {};

    if ($opts->{indent_blank_lines} // 1) {
        $str =~ s/^/$indent/mg;
    } else {
        $str =~ s/^([^\r\n]*\S[^\r\n]*)/$indent$1/mg;
    }
    $str;
}

sub linenum {
    my ($str, $opts) = @_;
    $opts //= {};
    $opts->{width}      //= 4;
    $opts->{zeropad}    //= 0;
    $opts->{skip_empty} //= 1;

    my $i = 0;
    $str =~ s/^(([\t ]*\S)?.*)/
        sprintf(join("",
                     "%",
                     ($opts->{zeropad} && !($opts->{skip_empty}
                                                && !defined($2)) ? "0" : ""),
                     $opts->{width}, "s",
                     "|%s"),
                ++$i && $opts->{skip_empty} && !defined($2) ? "" : $i,
                $1)/meg;

    $str;
}

sub pad {
    my ($text, $width, $which, $padchar, $is_trunc) = @_;
    if ($which) {
        $which = substr($which, 0, 1);
    } else {
        $which = "r";
    }
    $padchar //= " ";

    my $w = length($text);
    if ($is_trunc && $w > $width) {
        $text = substr($text, 0, $width, 1);
    } else {
        if ($which eq 'l') {
            $text = ($padchar x ($width-$w)) . $text;
        } elsif ($which eq 'c') {
            my $n = int(($width-$w)/2);
            $text = ($padchar x $n) . $text . ($padchar x ($width-$w-$n));
        } else {
            $text .= ($padchar x ($width-$w));
        }
    }
    $text;
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

=head2 indent($indent, $str, \%opts) => STR

Indent every line in $str with $indent. Example:

 indent('  ', "one\ntwo\nthree") # "  one\n  two\n  three"

%opts is optional. Known options:

=over 4

=item * indent_blank_lines => BOOL (default 1)

If set to false, does not indent blank lines (i.e., lines containing only zero
or more whitespaces).

=back

=head2 linenum($str, \%opts) => STR

Add line numbers. For example:

     1|line1
     2|line2
      |
     4|line4

Known options:

=over 4

=item * width => INT (default: 4)

=item * zeropad => BOOL (default: 0)

If turned on, will output something like:

  0001|line1
  0002|line2
      |
  0004|line4

=item * skip_empty => BOOL (default: 1)

If set to false, keep printing line number even if line is empty:

     1|line1
     2|line2
     3|
     4|line4

=back

=head2 pad($text, $width[, $which[, $padchar[, $truncate]]]) => STR

Return C<$text> padded with C<$padchar> to C<$width> columns. C<$which> is
either "r" or "right" for padding on the right (the default if not specified),
"l" or "left" for padding on the right, or "c" or "center" or "centre" for
left+right padding to center the text.

C<$padchar> is whitespace if not specified. It should be string having the width
of 1 column.


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
