package SHARYANTO::String::Util;

use 5.010001;
use strict;
use warnings;

# VERSION

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       ltrim
                       rtrim
                       trim
                       ltrim_lines
                       rtrim_lines
                       trim_lines
                       trim_blank_lines
                       ellipsis
                       indent
                       linenum
                       pad
                       qqquote
                       single_quote
                       double_quote
                       common_prefix
                       common_suffix
               );

sub ltrim {
    my $str = shift;
    $str =~ s/\A\s+//s;
    $str;
}

sub rtrim {
    my $str = shift;
    $str =~ s/\s+\z//s;
    $str;
}

sub trim {
    my $str = shift;
    $str =~ s/\A\s+//s;
    $str =~ s/\s+\z//s;
    $str;
}

sub ltrim_lines {
    my $str = shift;
    $str =~ s/^[ \t]+//mg; # XXX other unicode non-newline spaces
    $str;
}

sub rtrim_lines {
    my $str = shift;
    $str =~ s/[ \t]+$//mg;
    $str;
}

sub trim_lines {
    my $str = shift;
    $str =~ s/^[ \t]+//mg;
    $str =~ s/[ \t]+$//mg;
    $str;
}

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

# BEGIN COPY PASTE FROM Data::Dump
my %esc = (
    "\a" => "\\a",
    "\b" => "\\b",
    "\t" => "\\t",
    "\n" => "\\n",
    "\f" => "\\f",
    "\r" => "\\r",
    "\e" => "\\e",
);

# put a string value in double quotes
sub double_quote {
  local($_) = $_[0];
  # If there are many '"' we might want to use qq() instead
  s/([\\\"\@\$])/\\$1/g;
  return qq("$_") unless /[^\040-\176]/;  # fast exit

  s/([\a\b\t\n\f\r\e])/$esc{$1}/g;

  # no need for 3 digits in escape for these
  s/([\0-\037])(?!\d)/sprintf('\\%o',ord($1))/eg;

  s/([\0-\037\177-\377])/sprintf('\\x%02X',ord($1))/eg;
  s/([^\040-\176])/sprintf('\\x{%X}',ord($1))/eg;

  return qq("$_");
}
# END COPY PASTE FROM Data::Dump

# old name, deprecated, will be removed in the future
sub qqquote { goto &double_quote; }

# will write this in the future, will produce "qq(...)" and "q(...)" literal
# representation
#sub qq_quote {}
#sub q_quote {}

sub single_quote {
  local($_) = $_[0];
  s/([\\'])/\\$1/g;
  return qq('$_');
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

=head1 FUNCTIONS

=head2 ltrim($str) => STR

Trim whitespaces (including newlines) at the beginning of string. Equivalent to:

 $str =~ s/\A\s+//s;

=head2 ltrim_lines($str) => STR

Trim whitespaces (not including newlines) at the beginning of each line of
string. Equivalent to:

 $str =~ s/^\s+//mg;

=head2 rtrim($str) => STR

Trim whitespaces (including newlines) at the end of string. Equivalent to:

 $str =~ s/[ \t]+\z//s;

=head2 rtrim_lines($str) => STR

Trim whitespaces (not including newlines) at the end of each line of
string. Equivalent to:

 $str =~ s/[ \t]+$//mg;

=head2 trim($str) => STR

ltrim + rtrim.

=head2 trim_lines($str) => STR

ltrim_lines + rtrim_lines.

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

=head2 double_quote($str) => STR

Quote or encode C<$str> to the Perl double quote (C<">) literal representation
of the string. Example:

 say double_quote("a");        # => "a"     (with the quotes)
 say double_quote("a\n");      # => "a\n"
 say double_quote('"');        # => "\""
 say double_quote('$foo');     # => "\$foo"

This code is taken from C<quote()> in L<Data::Dump>. Maybe I didn't look more
closely, but I couldn't a module that provides a function to do something like
this. L<String::Escape>, for example, provides C<qqbackslash> but it does not
escape C<$>.

=head2 single_quote($str) => STR

Like C<double_quote> but will produce a Perl single quote literal representation
instead of the double quote ones. In single quotes, only literal backslash C<\>
and single quote character C<'> are escaped, the rest are displayed as-is, so
the result might span multiple lines or contain other non-printable characters.

 say single_quote("Mom's");    # => 'Mom\'s' (with the quotes)
 say single_quote("a\\");      # => 'a\\"
 say single_quote('"');        # => '"'
 say single_quote("\$foo");    # => '$foo'

=head2 common_prefix(@LIST) => STR

Given a list of strings, return common prefix.

=head2 common_suffix(@LIST) => STR

Given a list of strings, return common suffix.


=head1 SEE ALSO

L<SHARYANTO>

=cut
