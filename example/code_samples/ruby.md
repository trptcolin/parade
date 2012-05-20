!SLIDE

## Monkeypatching

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

!SLIDE

## Sharing with Modules

```ruby
module Measurements
  def ounces
    self
  end
end

class Fixnum
  include Measurements
end

class Float
  include Measurements
end
```
