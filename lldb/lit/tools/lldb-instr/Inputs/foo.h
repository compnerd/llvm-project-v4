struct Foo {
  Foo();
  Foo(int i);

  void A();
  void B(int i);
  int C(int i);
  int D(bool b) const;
  static void E();
  static int F(int i);
  int G() { return 0; }
};
