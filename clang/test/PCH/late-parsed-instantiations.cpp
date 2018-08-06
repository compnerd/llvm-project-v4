// RUN: %clang_cc1 -fdelayed-template-parsing -std=c++14 -emit-pch %s -o %t.pch -verify
// RUN: %clang_cc1 -fdelayed-template-parsing -std=c++14 -include-pch %t.pch %s -verify

#ifndef HEADER_INCLUDED

#define HEADER_INCLUDED

// pr33561
class ArrayBuffer;
template <typename T> class Trans_NS_WTF_RefPtr {
public:
  ArrayBuffer *operator->() { return nullptr; }
};
Trans_NS_WTF_RefPtr<ArrayBuffer> get();
template <typename _Visitor>
constexpr void visit(_Visitor __visitor) {
  __visitor(get()); // expected-note {{in instantiation}}
}
class ArrayBuffer {
  char data() {
    visit([](auto buffer) -> char { // expected-note {{in instantiation}}
      buffer->data();
    }); // expected-warning {{control reaches end of non-void lambda}}
  } // expected-warning {{control reaches end of non-void function}}
};

#else

// expected-no-diagnostics

#endif
