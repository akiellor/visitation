# Visitation

Visitation is a library for performing structural transformations on ruby data
structures using the visitor pattern.

## Installation

Add this line to your application's Gemfile:

    gem 'visitation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install visitation

## Usage

Visitation includes a number of Visitor implementations out of the box, some of
them include:

### Merge Template

Merges some data parameters into a template:

```ruby
template = {
    :a => [
      {:b => 5, :c => [{:d => 7, :e => 8}]}
    ]
}
data = {
    :a => [
        {:b => 6, :c => [{:d => 10, :e => 12}]},
        {:c => [{:d => 10}]}
    ]
}

result = Visitation::Visitors.merge_template template, data

result.should == {
    :a => [
        {:b => 6, :c => [{:d => 10, :e => 12}]},
        {:b => 5, :c => [{:d => 10, :e => 8}]}
    ]
}
```

### Visit for View

Extracts a sub tree from a data structure based on an existing data structure:

```ruby
input = {:foo => 0, :bar => 10}
description = {:foo => 5}

visitor = Visitation::Visitors.visit_for_view input, description

visitor.view.should == {:foo => 0}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
