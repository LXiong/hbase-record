class ShopInsight < HbaseRecord::Base

  # self.table_name = "aaa"

  # column_family :abc do
  #   qualifier :xx do
  #     field :name, :string
  #   end

  #   field :name
  # end

  column_family :daily do
    column /\d\d\d\d-\d\d-\d\d/ do
      column :visitors do
        column :in, :bigdecimal
        column :out, :bigdecimal
      end
    end
  end

end