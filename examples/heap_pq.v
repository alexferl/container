import x
import heap

// An Item is something we manage in a priority queue.
pub struct Item {
mut:
	value    string // The value of the item; arbitrary.
	priority int    // The priority of the item in the queue.
	// The index is needed by update and is maintained by the heap.Interface methods.
	index int // The index of the item in the heap.
}

// A PriorityQueue implements heap.Interface and holds Items.
type PriorityQueue = []Item

pub fn (pq PriorityQueue) len() int { return pq.len }

pub fn (pq PriorityQueue) less(i int, j int) bool {
	// We want pop to give us the highest, not lowest, priority so we use greater than here.
	return pq[i].priority > pq[j].priority
}

pub fn (mut pq PriorityQueue) swap(i int, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

pub fn (mut pq PriorityQueue) push(x Item) {
	n := pq.len
	mut item := x
	item.index = n
	pq << item
}

pub fn (mut pq PriorityQueue) pop() Item {
	mut old := pq
	n := old.len
	mut item := old[n-1]
	old[n-1] = unsafe { nil }
	item.index = -1 // for safety
	pq = old[0..n-1]
	return item
}

// update modifies the priority and value of an Item in the queue.
fn (mut pq PriorityQueue) update(mut item Item, value string, priority int) {
	item.value = value
	item.priority = priority
	heap.fix(pq, item.index)
}

fn main() {
	items := map[string]int{"banana": 3, "apple": 2, "pear": 4}

	// Create a priority queue, put the items in it, and
	// establish the priority queue (heap) invariants.
	mut pq := PriorityQueue{len: items.len}
	mut i := 0
	for value, priority in items {
		pq[i] = Item{
			value: value
			priority: priority
			index: i
		}
		i++
	}
	heap.init(mut pq)

	// Insert a new item and then modify its priority.
	item := Item{
		value: "orange"
		priority: 1
	}
	heap.push(mut pq, item)
	pq.update(item, item.value, 5)

	// Take the items out; they arrive in decreasing priority order.
	for pq.len() > 0 {
		it := heap.pop(pq)
		print('${it.priority}:${it.value} ')
	}
	// Output:
	// 05:orange 04:pear 03:banana 02:apple
}
