# Lab 01: Counted Loop

## Start in GitHub Codespaces

After accepting this Classroom 50 assignment, open your personal repository,
click **Code** → **Codespaces** → **Create codespace on main**. Wait for the
environment setup to finish, then use the terminal to run `make sim`.

## Overview

This lab uses a **counted loop** in ARM assembly to practice branching and condition flags.

The required source file is `test_lab01.s` in this repository's root.

## Learning Objectives

After completing this lab, you will be able to:

1. Build a loop with a label and unconditional branch (`B`)
2. Use `SUBS` to update a value and set flags
3. Use conditional branches (`B.NE`)
4. Use register-to-register arithmetic (`ADD`)

---

## Background

### What Is a Counted Loop?

A counted loop repeats a block of code a fixed number of times.

In this lab:

- `X0` is the loop counter (starts at `5`)
- `X4` is a running sum
- `X5` counts how many iterations occurred
- `X1` stores the constant value `1` so we can increment/decrement using a **register form** of `ADD`/`SUBS`

### Loop Algorithm

```text
1. Add counter (X0) to running sum (X4)
2. Increment iteration count (X5)
3. Decrement counter (X0)
4. If counter is not zero, loop back
5. When counter reaches zero, finish with YIELD
```

## Assignment

Open `test_lab01.s` and complete the TODO sections to implement a loop that:

- Starts with a counter value of `5`
- Adds the counter into a running sum each iteration
- Decrements the counter by `1`
- Repeats until the counter reaches `0`

Expected final values:

- `X0 = 0` (counter exhausted)
- `X4 = 15` (sum of `5 + 4 + 3 + 2 + 1`)
- `X5 = 5` (iteration count)

---

## Step-by-Step Instructions

### Step 1: Understand the Starter Code

The file already initializes:

- `X0 = 5` (loop counter)
- `X1 = 1` (constant for increment/decrement)
- `X4 = 0` (running sum)
- `X5 = 0` (iteration count)
- `sum_loop:` label
- `done:` label with `YIELD`

### Step 2: Add the Loop Instructions

Fill in the TODOs in `test_lab01.s` with these instructions:

```asm
sum_loop:
    ADD     X4, X4, X0      // Add counter into running sum
    ADD     X5, X5, X1      // Increment iteration count
    SUBS    X0, X0, X1      // Decrement counter and set flags
    B.NE    sum_loop        // Loop again while X0 != 0
```

### Step 3: Build and Run

Run:

```bash
make sim
```

### Step 4: Verify Success

You should see:

```text
[EDUCORE LOG]: Apollo has landed
```

### Step 5: Verify Register Values (Optional)

Open `dump.vcd` in Surfer and verify near the end of execution:

- `X0 = 0`
- `X4 = 15`
- `X5 = 5`

---

## Understanding the Instructions

### `ADD X4, X4, X0`

- Adds `X4 + X0`
- Stores the result back into `X4`
- Used here to build the running sum

### `ADD X5, X5, X1`

- Adds `1` to the iteration counter (because `X1 = 1`)
- We use register form `ADD`, which is compatible with this Educore build

### `SUBS X0, X0, X1`

- Subtracts `1` from the loop counter
- Stores result in `X0`
- Also updates condition flags (NZCV), which the next branch uses

### `B.NE sum_loop`

- Branches back to `sum_loop` if the Zero flag is **not** set
- In this lab, that means "branch if `X0` is not zero"

---

## Suggested Solution Pattern

You will use these supported instructions:

- `MOVZ`
- `ADD` (register form)
- `SUBS` (register form)
- `B.NE`
- `B`
- `YIELD`

---

## Common Issues

1. Using `ADD Xn, Xm, #1` (immediate form) may not work with this Educore build.
2. Using `CBZ` / `CBNZ` may not work with this Educore build.
3. Forgetting to branch back to the loop label causes only one iteration.
4. Using `SUB` instead of `SUBS` means flags are not updated, so `B.NE` may behave incorrectly.

### Example: Missing Flag Update

```asm
// ❌ WRONG - SUB does not update flags
SUB     X0, X0, X1
B.NE    sum_loop

// ✅ CORRECT - SUBS updates flags for B.NE
SUBS    X0, X0, X1
B.NE    sum_loop
```

### Example: Unsupported Immediate Increment Form

```asm
// ❌ May fail on this Educore build
ADD     X5, X5, #1

// ✅ Use register form with X1 = 1
ADD     X5, X5, X1
```

---

## Submission

```bash
git add .
git commit -m "Completed Lab 01"
git push
```

The autograder checks that:

- your file is not the untouched starter template
- the code assembles
- the simulation reaches `YIELD`
