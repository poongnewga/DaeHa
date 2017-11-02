class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :p_id
      t.string :p_writer
      t.text :p_message
      t.datetime :p_time
      t.integer :p_reactions_count
      t.integer :p_likes_count
      t.integer :p_loves_count
      t.integer :p_hahas_count
      t.integer :p_wows_count
      t.integer :p_sads_count
      t.integer :p_angrys_count
      t.string :c1_id
      t.string :c1_name
      t.text :c1_message
      t.string :c1_attachment
      t.datetime :c1_time
      t.integer :c1_reactions_count
      t.integer :c1_likes_count
      t.integer :c1_loves_count
      t.integer :c1_hahas_count
      t.integer :c1_wows_count
      t.integer :c1_sads_count
      t.integer :c1_angrys_count
      t.string :c2_id
      t.string :c2_name
      t.text :c2_message
      t.string :c2_attachment
      t.datetime :c2_time
      t.integer :c2_reactions_count
      t.integer :c2_likes_count
      t.integer :c2_loves_count
      t.integer :c2_hahas_count
      t.integer :c2_wows_count
      t.integer :c2_sads_count
      t.integer :c2_angrys_count

      t.timestamps
    end
  end
end
