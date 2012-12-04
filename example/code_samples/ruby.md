!SLIDE

## Ruby

```ruby
class Fixnum

  def ounces
    # vanity
    self
  end

  def cup
    # conversion to ounces
    self * 16
  end
end
```

!SLIDE execute

# Executable Ruby #

```ruby
[1, 2, 3].map { |n| n*7 }
```
