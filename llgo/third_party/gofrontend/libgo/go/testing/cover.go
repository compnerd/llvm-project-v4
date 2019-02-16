// Copyright 2013 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Support for test coverage.

package testing

import (
	"fmt"
	"os"
	"sync/atomic"
)

// CoverBlock records the coverage data for a single basic block.
// NOTE: This struct is internal to the testing infrastructure and may change.
// It is not covered (yet) by the Go 1 compatibility guidelines.
type CoverBlock struct {
	Line0 uint32
	Col0  uint16
	Line1 uint32
	Col1  uint16
	Stmts uint16
}

var cover Cover

// Cover records information about test coverage checking.
// NOTE: This struct is internal to the testing infrastructure and may change.
// It is not covered (yet) by the Go 1 compatibility guidelines.
type Cover struct {
	Mode            string
	Counters        map[string][]uint32
	Blocks          map[string][]CoverBlock
	CoveredPackages string
}

// Coverage reports the current code coverage as a fraction in the range [0, 1].
// If coverage is not enabled, Coverage returns 0.
//
// When running a large set of sequential test cases, checking Coverage after each one
// can be useful for identifying which test cases exercise new code paths.
// It is not a replacement for the reports generated by 'go test -cover' and
// 'go tool cover'.
func Coverage() float64 {
	var n, d int64
	for _, counters := range cover.Counters {
		for i := range counters {
			if atomic.LoadUint32(&counters[i]) > 0 {
				n++
			}
			d++
		}
	}
	if d == 0 {
		return 0
	}
	return float64(n) / float64(d)
}

// RegisterCover records the coverage data accumulators for the tests.
// NOTE: This function is internal to the testing infrastructure and may change.
// It is not covered (yet) by the Go 1 compatibility guidelines.
func RegisterCover(c Cover) {
	cover = c
}

// mustBeNil checks the error and, if present, reports it and exits.
func mustBeNil(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "testing: %s\n", err)
		os.Exit(2)
	}
}

// coverReport reports the coverage percentage and writes a coverage profile if requested.
func coverReport() {
	var f *os.File
	var err error
	if *coverProfile != "" {
		f, err = os.Create(toOutputDir(*coverProfile))
		mustBeNil(err)
		fmt.Fprintf(f, "mode: %s\n", cover.Mode)
		defer func() { mustBeNil(f.Close()) }()
	}

	var active, total int64
	var count uint32
	for name, counts := range cover.Counters {
		blocks := cover.Blocks[name]
		for i := range counts {
			stmts := int64(blocks[i].Stmts)
			total += stmts
			count = atomic.LoadUint32(&counts[i]) // For -mode=atomic.
			if count > 0 {
				active += stmts
			}
			if f != nil {
				_, err := fmt.Fprintf(f, "%s:%d.%d,%d.%d %d %d\n", name,
					blocks[i].Line0, blocks[i].Col0,
					blocks[i].Line1, blocks[i].Col1,
					stmts,
					count)
				mustBeNil(err)
			}
		}
	}
	if total == 0 {
		total = 1
	}
	fmt.Printf("coverage: %.1f%% of statements%s\n", 100*float64(active)/float64(total), cover.CoveredPackages)
}
