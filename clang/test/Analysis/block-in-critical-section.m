// RUN: %clang_analyze_cc1 -analyzer-checker=core,alpha.unix.BlockInCriticalSection -verify -Wno-objc-root-class %s

@interface SomeClass
-(void)someMethod;
@end

void shouldNotCrash(SomeClass *o) {
  [o someMethod];
}
