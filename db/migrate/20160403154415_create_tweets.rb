class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.datetime :created_at
      t.string :tweet_id
      t.integer :media_id
    end
  end
end
