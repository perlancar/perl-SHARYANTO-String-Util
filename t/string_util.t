#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.96;

use SHARYANTO::String::Util qw(trim_blank_lines ellipsis indent linenum);

ok( !defined(trim_blank_lines(undef)), "trim_blank_lines undef" );
is( trim_blank_lines("\n1\n\n2\n\n \n"), "1\n\n2\n", "trim_blank_lines 1" );

is(ellipsis("", 10), "", "ellipsis 1");
is(ellipsis("12345678", 10), "12345678", "ellipsis 1");
is(ellipsis("1234567890", 10), "1234567890", "ellipsis 2");
is(ellipsis("12345678901", 10), "1234567...", "ellipsis 3");
is(ellipsis("123456789012345", 10), "1234567...", "ellipsis 4");
is(ellipsis("12345678901", 10, "xxx"), "1234567xxx", "ellipsis 5");

is(indent('xx', "1\n2 \n3 3\n\n"), "xx1\nxx2 \nxx3 3\nxx\n", "indent 1");
is(indent('xx', "1\n\n2", {indent_blank_lines=>0}), "xx1\n\nxx2", "indent 2");

is(linenum("a\nb\n\nd"), "   1|a\n   2|b\n    |\n   4|d", "linenum 1");
is(linenum("a\nb\n\nd", {width=>2}),
   " 1|a\n 2|b\n  |\n 4|d", "linenum opt:width");
is(linenum("a\nb\n\nd", {zeropad=>1}),
   "0001|a\n0002|b\n    |\n0004|d", "linenum opt:zeropad");
is(linenum("a\nb\n\nd", {skip_empty=>0}),
   "   1|a\n   2|b\n   3|\n   4|d", "linenum opt:skip_empty");

DONE_TESTING:
done_testing();
