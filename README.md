hbase-record
============

Define a model
========

```ruby
class Test < HbaseRecord::Base
  column_familiy :cf1 do
    column :col, :string
  end
end
```


Access row by key
===========

```ruby
key = 'keystring'
Test.get(key)
```

