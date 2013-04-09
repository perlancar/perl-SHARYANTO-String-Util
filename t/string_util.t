#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::String::Util qw(trim_blank_lines ellipsis indent linenum pad);

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

my $str = "a\nb\n\n d\n0";
is(linenum($str),
   "   1|a\n   2|b\n    |\n   4| d\n   5|0", "linenum 1");
is(linenum($str, {width=>2}),
   " 1|a\n 2|b\n  |\n 4| d\n 5|0", "linenum opt:width");
is(linenum($str, {zeropad=>1}),
   "0001|a\n0002|b\n    |\n0004| d\n0005|0", "linenum opt:zeropad");
is(linenum($str, {skip_empty=>0}),
   "   1|a\n   2|b\n   3|\n   4| d\n   5|0", "linenum opt:skip_empty");

subtest "pad" => sub {
    is(pad("1234", 4), "1234");
    is(pad("1234", 6), "1234  ", "right");
    is(pad("1234", 6, "l"), "  1234", "left");
    is(pad("1234", 6, "c"), " 1234 ", "center");
    is(pad("1234", 6, "c", "x"), "x1234x", "padchar");
    is(pad("1234", 1), "1234", "trunc=0");
    is(pad("1234", 1, undef, undef, 1), "1", "trunc=1");
};

DONE_TESTING:
done_testing();
