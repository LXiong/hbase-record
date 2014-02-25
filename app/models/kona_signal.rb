class KonaSignal < HbaseRecord::Base
  self.table_name = "signals"
  column_family :signal do
    column :mac, :string
    column :quality, :short
    column :sensor_mac, :string
    column :time, :long
  end
  # 7febbc4758b5e370

  # column_family :abc do
  #   column :xx do
  #     cell :name, :string
  #   end
  #   cell :name
  # end

  # column_family :signal do
  #   cell :mac, :string
  #   cell :quality, :short
  # end

end
