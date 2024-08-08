class AddDefaultToVisibleInCards < ActiveRecord::Migration[6.0]
  def change
    change_column_default :cards, :visible, from: nil, to: false
  end
end