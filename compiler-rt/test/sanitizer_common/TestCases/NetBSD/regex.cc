// RUN: %clangxx -O0 -g %s -o %t && %run %t 2>&1 | FileCheck %s

#include <assert.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>

void test_matched(const regex_t *preg, const char *string) {
  int rv = regexec(preg, string, 0, NULL, 0);
  if (!rv)
    printf("%s: matched\n", string);
  else if (rv == REG_NOMATCH)
    printf("%s: not-matched\n", string);
  else
    abort();
}

void test_print_matches(const regex_t *preg, const char *string) {
  regmatch_t rm[10];
  int rv = regexec(preg, string, __arraycount(rm), rm, 0);
  if (!rv) {
    for (size_t i = 0; i < __arraycount(rm); i++) {
      // This condition shall be simplified, but verify that the data fields
      // are accessible.
      if (rm[i].rm_so == -1 && rm[i].rm_eo == -1)
        continue;
      printf("matched[%zu]='%.*s'\n", i, (int)(rm[i].rm_eo - rm[i].rm_so),
             string + rm[i].rm_so);
    }
  } else if (rv == REG_NOMATCH)
    printf("%s: not-matched\n", string);
  else
    abort();
}

void test_nsub(const regex_t *preg, const char *string) {
  regmatch_t rm[10];
  int rv = regexec(preg, string, __arraycount(rm), rm, 0);
  if (!rv) {
    char buf[1024];
    ssize_t ss = regnsub(buf, __arraycount(buf), "\\1xyz", rm, string);
    assert(ss != -1);

    printf("'%s' -> '%s'\n", string, buf);
  } else if (rv == REG_NOMATCH)
    printf("%s: not-matched\n", string);
  else
    abort();
}

void test_asub(const regex_t *preg, const char *string) {
  regmatch_t rm[10];
  int rv = regexec(preg, string, __arraycount(rm), rm, 0);
  if (!rv) {
    char *buf;
    ssize_t ss = regasub(&buf, "\\1xyz", rm, string);
    assert(ss != -1);

    printf("'%s' -> '%s'\n", string, buf);
    free(buf);
  } else if (rv == REG_NOMATCH)
    printf("%s: not-matched\n", string);
  else
    abort();
}

int main(void) {
  printf("regex\n");

  regex_t regex;
  int rv = regcomp(&regex, "[[:upper:]]\\([[:upper:]]\\)", 0);
  assert(!rv);

  test_matched(&regex, "abc");
  test_matched(&regex, "ABC");

  test_print_matches(&regex, "ABC");

  test_nsub(&regex, "ABC DEF");
  test_asub(&regex, "GHI JKL");

  regfree(&regex);

  rv = regcomp(&regex, "[[:upp:]]", 0);
  assert(rv);

  char errbuf[1024];
  regerror(rv, &regex, errbuf, sizeof errbuf);
  printf("error: %s\n", errbuf);

  // CHECK: regex
  // CHECK: abc: not-matched
  // CHECK: ABC: matched
  // CHECK: matched[0]='AB'
  // CHECK: matched[1]='B'
  // CHECK: 'ABC DEF' -> 'Bxyz'
  // CHECK: 'GHI JKL' -> 'Hxyz'
  // CHECK: error:{{.*}}

  return 0;
}
