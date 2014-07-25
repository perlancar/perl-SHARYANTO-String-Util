#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::String::Util qw(
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
                                  double_quote
                                  single_quote
                                  common_prefix
                                  common_suffix
                          );

subtest ltrim => sub {
    is(ltrim(" \ta")             , "a");
    is(ltrim("\n \ta")           , "a");
    is(ltrim("a \t")             , "a \t");
    is(ltrim("a\n \t")           , "a\n \t");
    is(ltrim(" \ta\n b\n")       , "a\n b\n");
    is(ltrim("a\n \tb \n\n")     , "a\n \tb \n\n");
};

subtest rtrim => sub {
    is(rtrim(" \ta")             , " \ta");
    is(rtrim("\n \ta")           , "\n \ta");
    is(rtrim("a \t")             , "a");
    is(rtrim("a\n \t")           , "a");
    is(rtrim(" \ta\n b\n")       , " \ta\n b");
    is(rtrim("a\n \tb \n\n")     , "a\n \tb");
};

subtest trim => sub {
    is(trim(" \ta")             , "a");
    is(trim("\n \ta")           , "a");
    is(trim("a \t")             , "a");
    is(trim("a\n \t")           , "a");
    is(trim(" \ta\n b\n")       , "a\n b");
    is(trim("a\n \tb \n\n")     , "a\n \tb");
};

subtest ltrim_lines => sub {
    is(ltrim_lines(" \ta")             , "a");
    is(ltrim_lines("\n \ta")           , "\na");
    is(ltrim_lines("a \t")             , "a \t");
    is(ltrim_lines("a\n \t")           , "a\n");
    is(ltrim_lines(" \ta\n b\n")       , "a\nb\n");
    is(ltrim_lines("a\n \tb \n\n")     , "a\nb \n\n");
};

subtest rtrim_lines => sub {
    is(rtrim_lines(" \ta")             , " \ta");
    is(rtrim_lines("\n \ta")           , "\n \ta");
    is(rtrim_lines("a \t")             , "a");
    is(rtrim_lines("a\n \t")           , "a\n");
    is(rtrim_lines(" \ta\n b\n")       , " \ta\n b\n");
    is(rtrim_lines("a\n \tb \n\n")     , "a\n \tb\n\n");
};

subtest trim_lines => sub {
    is(trim_lines(" \ta")             , "a");
    is(trim_lines("\n \ta")           , "\na");
    is(trim_lines("a \t")             , "a");
    is(trim_lines("a\n \t")           , "a\n");
    is(trim_lines(" \ta\n b\n")       , "a\nb\n");
    is(trim_lines("a\n \tb \n\n")     , "a\nb\n\n");
};

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

subtest "double_quote" => sub {
    is(double_quote("a"),    '"a"');
    is(double_quote("a\n"),  '"a\\n"');
    is(double_quote('"'),    '"\\""');
    is(double_quote('$foo'), '"\\$foo"');
};

subtest "single_quote" => sub {
    is(single_quote("a\"'\$\\"), qq('a"\\'\$\\\\'));
    is(single_quote("a\nb"), q('a
b'));
};

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
