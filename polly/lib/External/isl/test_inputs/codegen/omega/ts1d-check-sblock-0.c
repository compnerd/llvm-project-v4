{
  for (int c1 = 0; c1 <= 1; c1 += 1) {
    if (c1 == 1) {
      s0(1, 1, 1, 0, 0);
      s0(1, 1, 1, N - 1, 0);
    } else {
      for (int c3 = 0; c3 < N; c3 += 1)
        s0(1, 0, 1, c3, 0);
    }
  }
  for (int c1 = 0; c1 <= floord(T - 1, 1000); c1 += 1)
    for (int c2 = 1000 * c1 + 1; c2 <= min(N + T - 3, N + 1000 * c1 + 997); c2 += 1)
      for (int c3 = max(0, -N - 1000 * c1 + c2 + 2); c3 <= min(min(999, T - 1000 * c1 - 1), -1000 * c1 + c2 - 1); c3 += 1)
        s1(2, 1000 * c1 + c3, 1, -1000 * c1 + c2 - c3, 1);
}
