## Assignment 1
- Name: Chi Chun Chen
- Course: CSC453
- Iteration stop when all the element in each has already yielded the block
    - In this assignment, the `each` method in class `Triple` yield all of it's arguments, and then return itself before exit
- There are 143 unit tests in `spec/chichun_enum_spec` currently

### Installation
```
gem install bundler
bundle install
```

### Run
After the installation, just type ***rspec*** to run the spec

### File Structure
- All the implementations is in the lib `folder`, therefore, my implementation of the Enumerate module and the Triple class is in this folder.
- All the unit testing files are in the `spec` folder.
    - The `spec_helper` in spec folder is for Rspec to manage the test.
- Tree Structure of the file structure:
```
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── lib
│   └── chichun_enum.rb
└── spec
    ├── chichun_enum_spec.rb
    └── spec_helper.rb
```

### Notes
- RSpec is a tool for behavior driven test process, it allows developers to describe a sequences of actions,
and build our test case in whatever situation
- Simple case of writing tests using RSpec:
    - Firstly, use the keyword `describe` to describe the method you'd like to test
    - And then use keyword `context` to indicate the current situation, such as:
        - Whether the method has argument
        - Whether the method get block as argument
    - Finally, write the unit tests in the `it` block
- The output hierarchy of `RSpec`
    - If unit tests is written in a `context` block, then the output of tests indent
    - Method `all?` and `any?` can both accept calling without block, therefore, I put the tests in the `context` block, and all of the unit tests inside the `context` block indent

```
#all?
  return true if all three elements in t > 0
  return false if one of the elements in t < 0
  when block not given
    return false if there are any elements that is nil
    return false if there are any elements that is false
    return true if there no elements that is false or nil

#any?
  returns true if there is one element greater than 0
  returns false since there is no elements in t greater than 0
  when block not given
    return true if there are any elements?
    return false if no any elements?
```
- All of the method I wrote in `describe` added `#` as prefix, which means it's not an instance method, an instance method should be write as `.foo`

### Test of infinite loop
- From the ruby doc, if no argument is given or nil is given as an argument, then method `cycle` go into an infinite loop
- My way of testing infinite loop is to create a thread and then call `cycle()` or `cycle(nil)` inside that thread to make sure that the test is not blocked
- And then call sleep(x) in main thread to wait for the loop
    - x is an arbitrary time which is not too short for setting the loop flag, and not too long to block our test suite
- The body of the loop set a flag to indicate that while calling `cycle`, the program really go into the loop, after a arbitrary time, main thread kill the created thread, and test the flag

### Implementation
- How to return `Enumerator` class if block not given
    - `to_enum(:name_of_this_method, arg1, arg2, ..., argn) unless block_given?`

### Reference
- http://rspec.info/
- http://www.betterspecs.org/
