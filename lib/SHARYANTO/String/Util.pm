package SHARYANTO::String::Util;

use 5.010001;
use strict;
use warnings;

# VERSION

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       ellipsis
                       indent
                       linenum
                       common_prefix
                       common_suffix
               );

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

sub common_prefix {
    return undef unless @_;
    my $i;
  L1:
    for ($i=0; $i < length($_[0]); $i++) {
        for (@_[1..$#_]) {
            if (length($_) < $i) {
                $i--; last L1;
            } else {
                last L1 if substr($_, $i, 1) ne substr($_[0], $i, 1);
            }
        }
    }
    substr($_[0], 0, $i);
}

sub common_suffix {
    require List::Util;

    return undef unless @_;
    my $i;
  L1:
    for ($i = 0; $i < length($_[0]); $i++) {
        for (@_[1..$#_]) {
            if (length($_) < $i) {
                $i--; last L1;
            } else {
                last L1 if substr($_, -($i+1), 1) ne substr($_[0], -($i+1), 1);
            }
        }
    }
    $i ? substr($_[0], -$i) : "";
}

1;
# ABSTRACT: String utilities

=for Pod::Coverage ^(qqquote)$

=head1 FUNCTIONS

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

=head2 common_prefix(@LIST) => STR

Given a list of strings, return common prefix.

=head2 common_suffix(@LIST) => STR

Given a list of strings, return common suffix.


=head1 SEE ALSO

L<SHARYANTO>

=cut
