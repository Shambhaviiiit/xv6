#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

void
push(struct PriorityQueue* q, struct proc* p) {
  q->queue[q->front++] = p;
  q->front %= 65;
  if (q->front == q->back) {
    panic("Full queue push");
  }
  p->qstate = QUEUED;
}

struct proc*
pop(struct PriorityQueue* q)
{
  if (q->back == q->front) {
    panic("Empty queue pop");
  }
  struct proc* p = q->queue[q->back];
  p->qstate = NOTQUEUED;
  q->back++;
  q->back %= 65;
  return p;
}

void
remove(struct PriorityQueue* q, struct proc* p) {
  if (p->qstate == NOTQUEUED) return;
  for (int i = q->back; i != q->front; i = (i + 1) % 65) {
    if (q->queue[i] == p) {
      p->qstate = NOTQUEUED;
      for (int j = i + 1; j != q->front; j = (j + 1) % 65) {
        q->queue[(j - 1 + 65) % 65] = q->queue[j];
      }
      q->front = (q->front - 1 + 65) % 65;
      break;
    }
  }
}

int
empty(struct PriorityQueue q) {
  return (q.front - q.back + 65) % 65 == 0;
}
