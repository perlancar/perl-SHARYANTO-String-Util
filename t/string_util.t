#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::String::Util qw(
                                  ellipsis
                                  indent
                                  linenum
                                  common_prefix
                                  common_suffix
                          );

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

subtest "common_prefix" => sub {
    is(common_prefix(""), "");
    is(common_prefix("a", "", "bc"), "");
    is(common_prefix("a", "b"), "");
    is(common_prefix("a", "ab"), "a");
    is(common_prefix("a", "ab", "c"), "");
    is(common_prefix("ab", "ab", "abc"), "ab");
};

subtest "common_suffix" => sub {
    is(common_suffix(""), "");
    is(common_suffix("a", "", "bc"), "");
    is(common_suffix("a", "b"), "");
    is(common_suffix("a", "ba"), "a");
    is(common_suffix("a", "ba", "c"), "");
    is(common_suffix("ba", "ba", "cba"), "ba");
};

DONE_TESTING:
done_testing();
