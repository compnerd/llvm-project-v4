// RUN: %clang_cc1 -std=c++17 -triple x86_64-unknown-unknown -ast-dump=json %s | FileCheck -strict-whitespace %s

template <typename Ty>
void a(Ty);

template <typename... Ty>
void b(Ty...);

template <class Ty, typename Uy>
void c(Ty);

template <>
void c<float, int>(float);

template <typename Ty, template<typename> typename Uy>
void d(Ty, Uy<Ty>);

template <class Ty>
void e(Ty);

template <int N>
void f(int i = N);

template <typename Ty = int>
void g(Ty);

template <typename = void>
void h();

template <typename Ty>
struct R {};

template <>
struct R<int> {};

template <typename Ty, class Uy>
struct S {};

template <typename Ty>
struct S<Ty, int> {};

template <auto>
struct T {};

template <decltype(auto)>
struct U {};

template <typename Ty>
struct V {
  template <typename Uy>
  void f();
};

template <typename Ty>
template <typename Uy>
void V<Ty>::f() {}



// CHECK:  "kind": "TranslationUnitDecl",
// CHECK-NEXT:  "loc": {},
// CHECK-NEXT:  "range": {
// CHECK-NEXT:   "begin": {},
// CHECK-NEXT:   "end": {}
// CHECK-NEXT:  },
// CHECK-NEXT:  "inner": [
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "TypedefDecl",
// CHECK-NEXT:    "loc": {},
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {},
// CHECK-NEXT:     "end": {}
// CHECK-NEXT:    },
// CHECK-NEXT:    "isImplicit": true,
// CHECK-NEXT:    "name": "__int128_t",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "__int128"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "BuiltinType",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "__int128"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "TypedefDecl",
// CHECK-NEXT:    "loc": {},
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {},
// CHECK-NEXT:     "end": {}
// CHECK-NEXT:    },
// CHECK-NEXT:    "isImplicit": true,
// CHECK-NEXT:    "name": "__uint128_t",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "unsigned __int128"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "BuiltinType",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "unsigned __int128"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "TypedefDecl",
// CHECK-NEXT:    "loc": {},
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {},
// CHECK-NEXT:     "end": {}
// CHECK-NEXT:    },
// CHECK-NEXT:    "isImplicit": true,
// CHECK-NEXT:    "name": "__NSConstantString",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "__NSConstantString_tag"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "RecordType",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "__NSConstantString_tag"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "TypedefDecl",
// CHECK-NEXT:    "loc": {},
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {},
// CHECK-NEXT:     "end": {}
// CHECK-NEXT:    },
// CHECK-NEXT:    "isImplicit": true,
// CHECK-NEXT:    "name": "__builtin_ms_va_list",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "char *"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "PointerType",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "char *"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "BuiltinType",
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "char"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "TypedefDecl",
// CHECK-NEXT:    "loc": {},
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {},
// CHECK-NEXT:     "end": {}
// CHECK-NEXT:    },
// CHECK-NEXT:    "isImplicit": true,
// CHECK-NEXT:    "name": "__builtin_va_list",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "__va_list_tag [1]"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "ConstantArrayType",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "__va_list_tag [1]"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "RecordType",
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "__va_list_tag"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 4
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 3
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 10,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 4
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "a",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 3
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 3
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 3
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 4
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 4
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 10,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 4
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "a",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 10,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 4
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 4
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 4
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 7
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 6
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 13,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 7
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "b",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 23,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 6
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 6
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 23,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 6
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0,
// CHECK-NEXT:      "isParameterPack": true
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 7
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 7
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 13,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 7
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "b",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty...)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 13,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 7
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 7
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 10,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 7
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty..."
// CHECK-NEXT:        },
// CHECK-NEXT:        "isParameterPack": true
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 10
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 9
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 10,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 10
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "c",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 17,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 9
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 9
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 9
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "class",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 30,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 9
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 21,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 9
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 30,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 9
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Uy",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 1
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 10
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 10
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 10,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 10
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "c",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 10,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 10
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 10
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 10
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "name": "c",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (float)"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 13
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 12
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 25,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 13
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "previousDecl": "0x{{.*}}",
// CHECK-NEXT:    "name": "c",
// CHECK-NEXT:    "type": {
// CHECK-NEXT:     "qualType": "void (float)"
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "kind": "TemplateArgument",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "float"
// CHECK-NEXT:      }
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "kind": "TemplateArgument",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      }
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "ParmVarDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 25,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 13
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 13
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 13
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "float"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 16
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 15
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 18,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 16
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "d",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 15
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 15
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 15
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTemplateParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 52,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 15
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 24,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 15
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 52,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 15
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Uy",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 1,
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 33,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 15
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 33,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 15
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 33,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 15
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "tagUsed": "typename",
// CHECK-NEXT:        "depth": 1,
// CHECK-NEXT:        "index": 0
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 16
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 16
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 18,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 16
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "d",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty, Uy<Ty>)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 10,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 16
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 16
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 16
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty"
// CHECK-NEXT:        }
// CHECK-NEXT:       },
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 18,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 16
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 12,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 16
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 17,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 16
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Uy<Ty>"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 19
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 18
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 10,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 19
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "e",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 17,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 18
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 18
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 18
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "class",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 19
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 19
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 10,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 19
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "e",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 10,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 19
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 19
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 19
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 22
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 21
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 17,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 22
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "f",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "NonTypeTemplateParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 15,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 21
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 21
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 15,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 21
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "N",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      },
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 22
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 22
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 17,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 22
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "f",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (int)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 12,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 22
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 22
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 16,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 22
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "name": "i",
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        },
// CHECK-NEXT:        "init": "c",
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}",
// CHECK-NEXT:          "kind": "DeclRefExpr",
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 16,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 22
// CHECK-NEXT:           },
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 16,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 22
// CHECK-NEXT:           }
// CHECK-NEXT:          },
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "int"
// CHECK-NEXT:          },
// CHECK-NEXT:          "valueCategory": "rvalue",
// CHECK-NEXT:          "referencedDecl": {
// CHECK-NEXT:           "id": "0x{{.*}}",
// CHECK-NEXT:           "kind": "NonTypeTemplateParmDecl",
// CHECK-NEXT:           "name": "N",
// CHECK-NEXT:           "type": {
// CHECK-NEXT:            "qualType": "int"
// CHECK-NEXT:           }
// CHECK-NEXT:          }
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 25
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 24
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 10,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 25
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "g",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 24
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 24
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 25,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 24
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0,
// CHECK-NEXT:      "defaultArg": {
// CHECK-NEXT:       "kind": "TemplateArgument",
// CHECK-NEXT:       "type": {
// CHECK-NEXT:        "qualType": "int"
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "kind": "TemplateArgument",
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "int"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 25
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 25
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 10,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 25
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "g",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void (Ty)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "ParmVarDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 10,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 25
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 25
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 25
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "Ty"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 6,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 28
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 27
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 8,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 28
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "h",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 11,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 27
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 27
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 22,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 27
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0,
// CHECK-NEXT:      "defaultArg": {
// CHECK-NEXT:       "kind": "TemplateArgument",
// CHECK-NEXT:       "type": {
// CHECK-NEXT:        "qualType": "void"
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "kind": "TemplateArgument",
// CHECK-NEXT:        "type": {
// CHECK-NEXT:         "qualType": "void"
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "FunctionDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 6,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 28
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 28
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 8,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 28
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "h",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void ()"
// CHECK-NEXT:      }
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 31
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 30
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 11,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 31
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "R",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 30
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 30
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 30
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 31
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 31
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 31
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "R",
// CHECK-NEXT:      "tagUsed": "struct",
// CHECK-NEXT:      "completeDefinition": true,
// CHECK-NEXT:      "definitionData": {
// CHECK-NEXT:       "canConstDefaultInit": true,
// CHECK-NEXT:       "copyAssign": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "copyCtor": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "defaultCtor": {
// CHECK-NEXT:        "defaultedIsConstexpr": true,
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "isConstexpr": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "dtor": {
// CHECK-NEXT:        "irrelevant": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:       "isAggregate": true,
// CHECK-NEXT:       "isEmpty": true,
// CHECK-NEXT:       "isLiteral": true,
// CHECK-NEXT:       "isPOD": true,
// CHECK-NEXT:       "isStandardLayout": true,
// CHECK-NEXT:       "isTrivial": true,
// CHECK-NEXT:       "isTriviallyCopyable": true,
// CHECK-NEXT:       "moveAssign": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "moveCtor": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CXXRecordDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 31
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 1,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 31
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 31
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "isImplicit": true,
// CHECK-NEXT:        "name": "R",
// CHECK-NEXT:        "tagUsed": "struct"
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "ClassTemplateSpecializationDecl",
// CHECK-NEXT:      "name": "R"
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateSpecializationDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 34
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 33
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 16,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 34
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "R",
// CHECK-NEXT:    "tagUsed": "struct",
// CHECK-NEXT:    "completeDefinition": true,
// CHECK-NEXT:    "definitionData": {
// CHECK-NEXT:     "canConstDefaultInit": true,
// CHECK-NEXT:     "canPassInRegisters": true,
// CHECK-NEXT:     "copyAssign": {
// CHECK-NEXT:      "hasConstParam": true,
// CHECK-NEXT:      "implicitHasConstParam": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "copyCtor": {
// CHECK-NEXT:      "hasConstParam": true,
// CHECK-NEXT:      "implicitHasConstParam": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "defaultCtor": {
// CHECK-NEXT:      "defaultedIsConstexpr": true,
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "isConstexpr": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "dtor": {
// CHECK-NEXT:      "irrelevant": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:     "isAggregate": true,
// CHECK-NEXT:     "isEmpty": true,
// CHECK-NEXT:     "isLiteral": true,
// CHECK-NEXT:     "isPOD": true,
// CHECK-NEXT:     "isStandardLayout": true,
// CHECK-NEXT:     "isTrivial": true,
// CHECK-NEXT:     "isTriviallyCopyable": true,
// CHECK-NEXT:     "moveAssign": {
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "moveCtor": {
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "kind": "TemplateArgument",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      }
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 34
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 34
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 8,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 34
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isImplicit": true,
// CHECK-NEXT:      "name": "R",
// CHECK-NEXT:      "tagUsed": "struct"
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 37
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 36
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 11,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 37
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "S",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 36
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 36
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 36
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 30,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 36
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 24,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 36
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 30,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 36
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Uy",
// CHECK-NEXT:      "tagUsed": "class",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 1
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 37
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 37
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 37
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "S",
// CHECK-NEXT:      "tagUsed": "struct",
// CHECK-NEXT:      "completeDefinition": true,
// CHECK-NEXT:      "definitionData": {
// CHECK-NEXT:       "canConstDefaultInit": true,
// CHECK-NEXT:       "copyAssign": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "copyCtor": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "defaultCtor": {
// CHECK-NEXT:        "defaultedIsConstexpr": true,
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "isConstexpr": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "dtor": {
// CHECK-NEXT:        "irrelevant": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:       "isAggregate": true,
// CHECK-NEXT:       "isEmpty": true,
// CHECK-NEXT:       "isLiteral": true,
// CHECK-NEXT:       "isPOD": true,
// CHECK-NEXT:       "isStandardLayout": true,
// CHECK-NEXT:       "isTrivial": true,
// CHECK-NEXT:       "isTriviallyCopyable": true,
// CHECK-NEXT:       "moveAssign": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "moveCtor": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CXXRecordDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 37
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 1,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 37
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 37
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "isImplicit": true,
// CHECK-NEXT:        "name": "S",
// CHECK-NEXT:        "tagUsed": "struct"
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplatePartialSpecializationDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 40
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 39
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 20,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 40
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "S",
// CHECK-NEXT:    "tagUsed": "struct",
// CHECK-NEXT:    "completeDefinition": true,
// CHECK-NEXT:    "definitionData": {
// CHECK-NEXT:     "canConstDefaultInit": true,
// CHECK-NEXT:     "copyAssign": {
// CHECK-NEXT:      "hasConstParam": true,
// CHECK-NEXT:      "implicitHasConstParam": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "copyCtor": {
// CHECK-NEXT:      "hasConstParam": true,
// CHECK-NEXT:      "implicitHasConstParam": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "defaultCtor": {
// CHECK-NEXT:      "defaultedIsConstexpr": true,
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "isConstexpr": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "dtor": {
// CHECK-NEXT:      "irrelevant": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:     "isAggregate": true,
// CHECK-NEXT:     "isEmpty": true,
// CHECK-NEXT:     "isLiteral": true,
// CHECK-NEXT:     "isPOD": true,
// CHECK-NEXT:     "isStandardLayout": true,
// CHECK-NEXT:     "isTrivial": true,
// CHECK-NEXT:     "isTriviallyCopyable": true,
// CHECK-NEXT:     "moveAssign": {
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     },
// CHECK-NEXT:     "moveCtor": {
// CHECK-NEXT:      "exists": true,
// CHECK-NEXT:      "needsImplicit": true,
// CHECK-NEXT:      "simple": true,
// CHECK-NEXT:      "trivial": true
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "kind": "TemplateArgument",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "type-parameter-0-0"
// CHECK-NEXT:      }
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "kind": "TemplateArgument",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "int"
// CHECK-NEXT:      }
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 39
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 39
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 39
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isReferenced": true,
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 40
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 40
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 8,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 40
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "isImplicit": true,
// CHECK-NEXT:      "name": "S",
// CHECK-NEXT:      "tagUsed": "struct"
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 43
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 42
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 11,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 43
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "T",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "NonTypeTemplateParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 15,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 42
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 42
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 42
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "auto"
// CHECK-NEXT:      },
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 43
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 43
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 43
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "T",
// CHECK-NEXT:      "tagUsed": "struct",
// CHECK-NEXT:      "completeDefinition": true,
// CHECK-NEXT:      "definitionData": {
// CHECK-NEXT:       "canConstDefaultInit": true,
// CHECK-NEXT:       "copyAssign": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "copyCtor": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "defaultCtor": {
// CHECK-NEXT:        "defaultedIsConstexpr": true,
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "isConstexpr": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "dtor": {
// CHECK-NEXT:        "irrelevant": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:       "isAggregate": true,
// CHECK-NEXT:       "isEmpty": true,
// CHECK-NEXT:       "isLiteral": true,
// CHECK-NEXT:       "isPOD": true,
// CHECK-NEXT:       "isStandardLayout": true,
// CHECK-NEXT:       "isTrivial": true,
// CHECK-NEXT:       "isTriviallyCopyable": true,
// CHECK-NEXT:       "moveAssign": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "moveCtor": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CXXRecordDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 43
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 1,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 43
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 43
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "isImplicit": true,
// CHECK-NEXT:        "name": "T",
// CHECK-NEXT:        "tagUsed": "struct"
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 46
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 45
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 11,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 46
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "U",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "NonTypeTemplateParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 25,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 45
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 45
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 45
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "decltype(auto)"
// CHECK-NEXT:      },
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 46
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 46
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 46
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "U",
// CHECK-NEXT:      "tagUsed": "struct",
// CHECK-NEXT:      "completeDefinition": true,
// CHECK-NEXT:      "definitionData": {
// CHECK-NEXT:       "canConstDefaultInit": true,
// CHECK-NEXT:       "copyAssign": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "copyCtor": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "defaultCtor": {
// CHECK-NEXT:        "defaultedIsConstexpr": true,
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "isConstexpr": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "dtor": {
// CHECK-NEXT:        "irrelevant": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:       "isAggregate": true,
// CHECK-NEXT:       "isEmpty": true,
// CHECK-NEXT:       "isLiteral": true,
// CHECK-NEXT:       "isPOD": true,
// CHECK-NEXT:       "isStandardLayout": true,
// CHECK-NEXT:       "isTrivial": true,
// CHECK-NEXT:       "isTriviallyCopyable": true,
// CHECK-NEXT:       "moveAssign": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "moveCtor": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CXXRecordDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 46
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 1,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 46
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 46
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "isImplicit": true,
// CHECK-NEXT:        "name": "U",
// CHECK-NEXT:        "tagUsed": "struct"
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "ClassTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 8,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 49
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 48
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 52
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "name": "V",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 48
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 48
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 48
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Ty",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 0,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXRecordDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 8,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 49
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 49
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 52
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "V",
// CHECK-NEXT:      "tagUsed": "struct",
// CHECK-NEXT:      "completeDefinition": true,
// CHECK-NEXT:      "definitionData": {
// CHECK-NEXT:       "canConstDefaultInit": true,
// CHECK-NEXT:       "copyAssign": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "copyCtor": {
// CHECK-NEXT:        "hasConstParam": true,
// CHECK-NEXT:        "implicitHasConstParam": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "defaultCtor": {
// CHECK-NEXT:        "defaultedIsConstexpr": true,
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "isConstexpr": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "dtor": {
// CHECK-NEXT:        "irrelevant": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "hasConstexprNonCopyMoveConstructor": true,
// CHECK-NEXT:       "isAggregate": true,
// CHECK-NEXT:       "isEmpty": true,
// CHECK-NEXT:       "isLiteral": true,
// CHECK-NEXT:       "isPOD": true,
// CHECK-NEXT:       "isStandardLayout": true,
// CHECK-NEXT:       "isTrivial": true,
// CHECK-NEXT:       "isTriviallyCopyable": true,
// CHECK-NEXT:       "moveAssign": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       },
// CHECK-NEXT:       "moveCtor": {
// CHECK-NEXT:        "exists": true,
// CHECK-NEXT:        "needsImplicit": true,
// CHECK-NEXT:        "simple": true,
// CHECK-NEXT:        "trivial": true
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CXXRecordDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 49
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 1,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 49
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 8,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 49
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "isImplicit": true,
// CHECK-NEXT:        "name": "V",
// CHECK-NEXT:        "tagUsed": "struct"
// CHECK-NEXT:       },
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "FunctionTemplateDecl",
// CHECK-NEXT:        "loc": {
// CHECK-NEXT:         "col": 8,
// CHECK-NEXT:         "file": "{{.*}}",
// CHECK-NEXT:         "line": 51
// CHECK-NEXT:        },
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 3,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 50
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 10,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 51
// CHECK-NEXT:         }
// CHECK-NEXT:        },
// CHECK-NEXT:        "name": "f",
// CHECK-NEXT:        "inner": [
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}",
// CHECK-NEXT:          "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:          "loc": {
// CHECK-NEXT:           "col": 22,
// CHECK-NEXT:           "file": "{{.*}}",
// CHECK-NEXT:           "line": 50
// CHECK-NEXT:          },
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 13,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 50
// CHECK-NEXT:           },
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 22,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 50
// CHECK-NEXT:           }
// CHECK-NEXT:          },
// CHECK-NEXT:          "name": "Uy",
// CHECK-NEXT:          "tagUsed": "typename",
// CHECK-NEXT:          "depth": 1,
// CHECK-NEXT:          "index": 0
// CHECK-NEXT:         },
// CHECK-NEXT:         {
// CHECK-NEXT:          "id": "0x{{.*}}",
// CHECK-NEXT:          "kind": "CXXMethodDecl",
// CHECK-NEXT:          "loc": {
// CHECK-NEXT:           "col": 8,
// CHECK-NEXT:           "file": "{{.*}}",
// CHECK-NEXT:           "line": 51
// CHECK-NEXT:          },
// CHECK-NEXT:          "range": {
// CHECK-NEXT:           "begin": {
// CHECK-NEXT:            "col": 3,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 51
// CHECK-NEXT:           },
// CHECK-NEXT:           "end": {
// CHECK-NEXT:            "col": 10,
// CHECK-NEXT:            "file": "{{.*}}",
// CHECK-NEXT:            "line": 51
// CHECK-NEXT:           }
// CHECK-NEXT:          },
// CHECK-NEXT:          "name": "f",
// CHECK-NEXT:          "type": {
// CHECK-NEXT:           "qualType": "void ()"
// CHECK-NEXT:          }
// CHECK-NEXT:         }
// CHECK-NEXT:        ]
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   },
// CHECK-NEXT:   {
// CHECK-NEXT:    "id": "0x{{.*}}",
// CHECK-NEXT:    "kind": "FunctionTemplateDecl",
// CHECK-NEXT:    "loc": {
// CHECK-NEXT:     "col": 13,
// CHECK-NEXT:     "file": "{{.*}}",
// CHECK-NEXT:     "line": 56
// CHECK-NEXT:    },
// CHECK-NEXT:    "range": {
// CHECK-NEXT:     "begin": {
// CHECK-NEXT:      "col": 1,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 55
// CHECK-NEXT:     },
// CHECK-NEXT:     "end": {
// CHECK-NEXT:      "col": 18,
// CHECK-NEXT:      "file": "{{.*}}",
// CHECK-NEXT:      "line": 56
// CHECK-NEXT:     }
// CHECK-NEXT:    },
// CHECK-NEXT:    "parentDeclContext": "0x{{.*}}",
// CHECK-NEXT:    "previousDecl": "0x{{.*}}",
// CHECK-NEXT:    "name": "f",
// CHECK-NEXT:    "inner": [
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "TemplateTypeParmDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 20,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 55
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 11,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 55
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 20,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 55
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "name": "Uy",
// CHECK-NEXT:      "tagUsed": "typename",
// CHECK-NEXT:      "depth": 1,
// CHECK-NEXT:      "index": 0
// CHECK-NEXT:     },
// CHECK-NEXT:     {
// CHECK-NEXT:      "id": "0x{{.*}}",
// CHECK-NEXT:      "kind": "CXXMethodDecl",
// CHECK-NEXT:      "loc": {
// CHECK-NEXT:       "col": 13,
// CHECK-NEXT:       "file": "{{.*}}",
// CHECK-NEXT:       "line": 56
// CHECK-NEXT:      },
// CHECK-NEXT:      "range": {
// CHECK-NEXT:       "begin": {
// CHECK-NEXT:        "col": 1,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 54
// CHECK-NEXT:       },
// CHECK-NEXT:       "end": {
// CHECK-NEXT:        "col": 18,
// CHECK-NEXT:        "file": "{{.*}}",
// CHECK-NEXT:        "line": 56
// CHECK-NEXT:       }
// CHECK-NEXT:      },
// CHECK-NEXT:      "parentDeclContext": "0x{{.*}}",
// CHECK-NEXT:      "previousDecl": "0x{{.*}}",
// CHECK-NEXT:      "name": "f",
// CHECK-NEXT:      "type": {
// CHECK-NEXT:       "qualType": "void ()"
// CHECK-NEXT:      },
// CHECK-NEXT:      "inner": [
// CHECK-NEXT:       {
// CHECK-NEXT:        "id": "0x{{.*}}",
// CHECK-NEXT:        "kind": "CompoundStmt",
// CHECK-NEXT:        "range": {
// CHECK-NEXT:         "begin": {
// CHECK-NEXT:          "col": 17,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 56
// CHECK-NEXT:         },
// CHECK-NEXT:         "end": {
// CHECK-NEXT:          "col": 18,
// CHECK-NEXT:          "file": "{{.*}}",
// CHECK-NEXT:          "line": 56
// CHECK-NEXT:         }
// CHECK-NEXT:        }
// CHECK-NEXT:       }
// CHECK-NEXT:      ]
// CHECK-NEXT:     }
// CHECK-NEXT:    ]
// CHECK-NEXT:   }
// CHECK-NEXT:  ]
// CHECK-NEXT: }

