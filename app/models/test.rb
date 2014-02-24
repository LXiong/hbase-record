class Test < HbaseRecord::Base
  # self.table_name = "signals"

  # 7febbc4758b5e370

  column_family :cf1 do
    field :sec, :string
    field :two, :string
  end

  # column :cf1 do
  #   field :sec, :string
  #   field :two, :string
  # end

  # column_family :cf2 do
  #   column :sec do
  #     field :third, :string
  #   end
  # end

end

# Test.get("key").cf1.sec.third => Value
# Test.get("key").cf1.two => Value