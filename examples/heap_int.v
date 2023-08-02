import heap

pub type IntHeap = []int

pub fn (h IntHeap) len() int { return h.len }
pub fn (h IntHeap) less(i int, j int) bool { return h[i] < h[j] }
pub fn (mut h IntHeap) swap(i int, j int)      { h[i], h[j] = h[j], h[i] }

pub fn (mut h IntHeap) push(x int) {
	h << x
}

pub fn (mut h IntHeap) pop() int {
	old := h
	n := old.len
	x := old[n-1]
	h = old[0..n-1]
	return x
}

fn main() {
	mut h := IntHeap([2, 1, 5])
	heap.init(mut h)
	heap.push(mut h, 3)
	println('minimum: ${h[0]}')
	for h.len() > 0 {
		print("${heap.pop(mut h)} ")
	}
	// Output:
	// minimum: 1
	// 1 2 3 5
}
