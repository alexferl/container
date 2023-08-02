// Module heap provides heap operations for any type that implements heap.Interface.
module heap

import alexferl.sort

// The Interface type describes the requirements
// for a type using the routines in this package.
// Any type that implements it may be used as a
// min-heap with the following invariants (established after
// Init has been called or if the data is empty or sorted):
//
//	!h.less(j, i) for 0 <= i < h.len() and 2*i+1 <= j <= 2*i+2 and j < h.len()
//
// Note that push and pop in this interface are for package heap's
// implementation to call. To add and remove things from the heap,
// use heap.push and heap.pop.
pub interface Interface {
	sort.Interface
mut:
	push(x int) // add x as element len()
	pop() int // remove and return element len() - 1.
}

// init establishes the heap invariants required by the other routines in this package.
// Init is idempotent with respect to the heap invariants
// and may be called whenever the heap invariants may have been invalidated.
// The complexity is O(n) where n = h.len().
pub fn init(mut h Interface) {
	// heapify
	n := h.len()
	for i := n / 2 - 1; i >= 0; i-- {
		down(mut h, i, n)
	}
}

// push pushes the element x onto the heap.
// The complexity is O(log n) where n = h.len().
pub fn push(mut h Interface, x int) {
	h.push(x)
	up(mut h, h.len() - 1)
}

// pop removes and returns the minimum element (according to less) from the heap.
// The complexity is O(log n) where n = h.len().
// pop is equivalent to remove(h, 0).
pub fn pop(mut h Interface) int {
	n := h.len() - 1
	h.swap(0, n)
	down(mut h, 0, n)
	return h.pop()
}

// remove removes and returns the element at index i from the heap.
// The complexity is O(log n) where n = h.len().
pub fn remove(mut h Interface, i int) int {
	n := h.len() - 1
	if n != i {
		h.swap(i, n)
		if !down(mut h, i, n) {
			up(mut h, i)
		}
	}
	return h.pop()
}

// fix re-establishes the heap ordering after the element at index i has changed its value.
// Changing the value of the element at index i and then calling fix is equivalent to,
// but less expensive than, calling remove(h, i) followed by a push of the new value.
// The complexity is O(log n) where n = h.len().
pub fn fix(mut h Interface, i int) {
	if !down(mut h, i, h.len()) {
		up(mut h, i)
	}
}

fn up(mut h Interface, j_ int) {
	mut j := j_
	for {
		i := (j - 1) / 2 // parent
		if i == j || !h.less(j, i) {
			break
		}
		h.swap(i, j)
		j = i
	}
}

fn down(mut h Interface, i0 int, n int) bool {
	mut i := i0
	for {
		j1 := 2 * i + 1
		if j1 >= n || j1 < 0 { // j1 < 0 after int overflow
			break
		}
		mut j := j1 // left child
		j2 := j1 + 1
		if j2 < n && h.less(j2, j1) {
			j = j2 // = 2*i + 2  // right child
		}
		if !h.less(j, i) {
			break
		}
		h.swap(i, j)
		i = j
	}
	return i > i0
}
