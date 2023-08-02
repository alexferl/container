module heap

import benchmark
import rand

type MyHeap = []int

fn (h MyHeap) less(i int, j int) bool {
	return h[i] < h[j]
}

fn (mut h MyHeap) swap(i int, j int) {
	h[i], h[j] = h[j], h[i]
}

fn (h MyHeap) len() int {
	return h.len
}

fn (mut h MyHeap) push(x int) {
	h << x
}

fn (mut h MyHeap) pop() int {
	mut v := 0
	h, v = h[..h.len() - 1], h[h.len() - 1] or { 0 }
	return v
}

fn (h MyHeap) verify(i int) {
	n := h.len()
	j1 := 2 * i + 1
	j2 := 2 * i + 2
	if j1 < n {
		assert !h.less(j1, i), 'heap invariant invalidated [${i}] = ${h[i]} > [${j1}] = ${h[j1]}'
		h.verify(j1)
	}
	if j2 < n {
		assert !h.less(j2, i), 'heap invariant invalidated [${i}] = ${h[i]} > [${j1}] = ${h[j2]}'
		h.verify(j2)
	}
}

fn test_init0() {
	mut h := MyHeap([]int{})
	for i := 20; i > 0; i-- {
		h.push(0) // all elements are the same
	}

	init(mut h)
	h.verify(0)

	for i := 1; h.len() > 0; i++ {
		x := pop(mut h)
		h.verify(0)
		assert x == 0, '${i}.th pop got ${x}; want ${0}'
	}
}

fn test_init1() {
	mut h := MyHeap([]int{})
	for i := 20; i > 0; i-- {
		h.push(i) // all elements are different
	}

	init(mut h)
	h.verify(0)

	for i := 1; h.len() > 0; i++ {
		x := pop(mut h)
		h.verify(0)
		assert x == i, '${i}.th pop got ${x}; want ${i}'
	}
}

fn test() {
	mut h := MyHeap([]int{})
	h.verify(0)

	for i := 20; i > 10; i-- {
		h.push(i)
	}
	init(mut h)
	h.verify(0)

	for i := 10; i > 0; i-- {
		push(mut h, i)
		h.verify(0)
	}

	for i := 1; h.len() > 0; i++ {
		x := pop(mut h)
		if i < 20 {
			push(mut h, 20 + i)
		}
		h.verify(0)
		assert x == i, '${i}.th pop got ${x}; want ${i}'
	}
}

fn test_remove0() {
	mut h := MyHeap([]int{})
	for i := 0; i < 10; i++ {
		h.push(i)
	}
	h.verify(0)

	for h.len() > 0 {
		i := h.len() - 1
		x := remove(mut h, i)
		assert x == i, 'remove(${i}) got ${x}; want ${i}'
		h.verify(0)
	}
}

fn test_remove1() {
	mut h := MyHeap([]int{})
	for i := 0; i < 10; i++ {
		h.push(i)
	}
	h.verify(0)

	for i := 0; h.len() > 0; i++ {
		x := remove(mut h, 0)
		assert x == i, 'remove(0) got ${x}; want ${i}'
		h.verify(0)
	}
}

fn test_remove2() {
	big_n := 10

	mut h := MyHeap([]int{})
	for i := 0; i < big_n; i++ {
		h.push(i)
	}
	h.verify(0)

	mut m := map[int]bool{}
	for h.len() > 0 {
		m[remove(mut h, (h.len() - 1) / 2)] = true
		h.verify(0)
	}

	assert m.len == big_n, 'm.len = ${m.len}; want ${big_n}'

	for i := 0; i < m.len; i++ {
		assert m[i], "m[${i}] doesn't exist"
	}
}

fn test_fix() {
	mut h := MyHeap([]int{})
	h.verify(0)

	for i := 200; i > 0; i -= 10 {
		push(mut h, i)
	}
	h.verify(0)

	assert h[0] == 10, 'Expected head to be 10, was ${h[0]}'
	h[0] = 210
	fix(mut h, 0)
	h.verify(0)

	for i := 100; i > 0; i-- {
		elem := rand.intn(h.len())!
		if i&1 == 0 {
			h[elem] *= 2
		} else {
			h[elem] /= 2
		}
		fix(mut h, elem)
		h.verify(0)
	}
}

fn test_benchmark_dup() {
	mut bmark := benchmark.new_benchmark()
	bmark.set_total_expected_steps(1000)

	for i := 0; i < bmark.nexpected_steps; i++ {
		n := 10000
		mut h := MyHeap([]int{len: 0, cap: n})
		bmark.step()
		for j := 0; j < n; j++ {
			push(mut h, 0) // all elements are the same
		}
		for h.len() > 0 {
			pop(mut h)
		}
		bmark.ok()
	}
	bmark.stop()
	bmark.measure(@FN)
}
