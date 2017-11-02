class AddC1ProfileToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :c1_profile, :string
    add_column :posts, :c2_profile, :string
  end
end
