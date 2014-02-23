class KonaSignal < HbaseRecord::Base
  self.table_name = "signals"

  # 7febbc4758b5e370

  column_family :abc do
    column :xx do
      cell :name, :string
    end
    cell :name
  end

  column_family :signal do
    cell :mac, :string
    cell :quality, :short
  end

end
