use Test2::V0;
use Test::Alien;
use Test::Alien::CanCompileCpp;

my $xs = do { local $/; <DATA> };

my $subtest = sub {
  my($module) = @_;
  is($module->get_value(), 42);
};

xs_ok {
  xs => $xs,
  pxs => { 'C++' => 1 },
  cbuilder_compile => { 'C++' => 1 },
}, 'by setting pxs and cbuilder_compile', with_subtest { $subtest->(@_) };

xs_ok {
  xs  => $xs,
  cpp => 1,
}, 'by setting cpp => 1', with_subtest { $subtest->(@_) };

xs_ok {
  xs  => $xs,
  'C++' => 1,
}, 'by setting C++ => 1', with_subtest { $subtest->(@_) };

done_testing;

__DATA__
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

class Foo {
public:
  static int get_a_value();
};

int Foo::get_a_value()
{
  return 42;
}

MODULE = TA_MODULE PACKAGE = TA_MODULE

int get_value(klass);
    const char *klass
  CODE:
    RETVAL = Foo::get_a_value();
  OUTPUT:
    RETVAL
  