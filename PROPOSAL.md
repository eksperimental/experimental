# Introducing random related functions

First I would like to address the need for: Integer.random/1
All functions using random numbers, are called :erlang.random_uniform/1
the erlang function is not zero based, so there is an overhead to deal with every time.

## Integer module

So I propose to add:
`Integer.random/1` and `Integer.random/2`

- `Integer.random(limit)` - returns a random integer from 0 to limit (possitive or negative integers)

- `Integer.random(lower_limit, upper_limit)` - returns a random integer withing two limits.

`Integer.pad_random` if we are about to generate huge numbers, `:erlang.random_uniform/1` will work to a certain limit.
the function can has options such are force_length, and return negative numbers, possitive, or both, including or excluding zero.

This list can generate incredible huge integers, with no permormance cost.


## Range module

- `Range.random(range)` - It returns an integer within range.
- `Range.random(range, count)` - It returns an list of count integers within range.


# Enum module

- `Enum.random(enumerable, count)` - It returns a list of count size, of random items from enumerable.
The main difference with `Enum.take_random/2` is that latter will not include repeated results, and if count is greater than the number of elements in the enumerable, it will return short. So `Enum.random/2` garantees the count of items, and allows them to be repeated.
