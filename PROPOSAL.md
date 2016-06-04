# Introducing random related functions

First I would like to address the need for implementing in Elixir our function for generating random integers: `Integer.random/1`.

All functions using random numbers, are calling `:erlang.random_uniform/1`. This Erlang function is not zero based, so there is an overhead to deal with it every time, adding and subtracting (`:rand.uniform(n + 1) - 1`), thus leading to potential bugs.


## Integer module

So my proposal is to add `Integer.random/1` and `Integer.random/2`

  - `Integer.random(limit)` - It returns a random integer from 0 to limit (positive or negative integers)

  - `Integer.random(lower_limit, upper_limit)` - It returns a random integer withing two limits.


## Range module

  - `Range.random(range)` - It returns an integer within range.

  - `Range.random(range, count)` - It returns an list of `count` integers within range. count can be bigger than the range size.

Uses cases: `Range.random/2` can be useful for generating charlists of random chars within a range. It is also used by `Enum.random/2` when the enumerable is a range.

## Enum module

  - `Enum.random(enumerable, count)` - It returns a list of count size, of random items from enumerable.
The main difference with `Enum.take_random/2` is that latter will not include repeated results, and if count is greater than the number of elements in the enumerable, it will return short. So `Enum.random/2` guarantees the count of items, and allows them to be repeated.

  - `Enum.random/1` has been updated to not to call `Enum.take_random/2`, but to use `Enum.at/3` instead.

  - `Enum.at/3` has been optimized to use `Range.at/3` when the enumerable is a range. 


## Additional functions implemented

### Integer.pad_random/2

If we are about to generate huge numbers, `:erlang.random_uniform/1` will work to a certain limit.
`Integer.pad_random/2` has fine tuning options such as:

  - force_size: true | false

  - return: :integer | :positive | :negative | :zero_or_positive | :zero_or_negative

This list can generate incredible HUGE integers, in a very efficient way.

Use cases: benchmarking functions with different integers and data size of specific length.

### Kernel.delta/2 and Range.delta/1

I took the chance and introduce new functions that helped me archive random related functions listed above.

  - `Kernel.delta(number1, number2)`: It returns the absolute difference between two numbers (integer or float).

  - `Range.delta(range)`: It returns the absolute difference between the range limits.

It may sound simple, but I had made mistakes in the past implementing a quick delta functions.


## Implemented code

It can be found here: https://github.com/eksperimental/experimental/tree/random

It can be cloned locally by running:

```sh
git clone -b random --single-branch https://github.com/eksperimental/experimental.git
```

Looking forward to hearing your opinion,

— Eksperimental

