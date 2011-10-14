class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name

      t.timestamps
    end
    counties = %w{Multnomah Washington Clackamas Hood\ River Columbia Yamhill Clatsop Polk Clark}
    counties.each do |county|
      County.create(:name => county)
    end
  end

  def self.down
    drop_table :counties
  end

end
