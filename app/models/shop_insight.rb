class ShopInsight < HbaseRecord::Base

  # self.table_name = "aaa"

  # column_family :abc do
  #   qualifier :xx do
  #     field :name, :string
  #   end

  #   field :name
  # end

  column_family :daily do
    column /^\d\d\d\d-\d\d-\d\d$/ do
      column :visitors_in, :bigdecimal
      column :visitors_out, :bigdecimal
      column :avg_dwell_time_in, :bigdecimal
      column :capture_rate, :float
      column :engaged_visitors, :bigdecimal
      column :engagement_rate_5, :float
      column :repeated_visitors, :bigdecimal
      column :retention_rate, :float
    end
  end


end