# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  validates :title, if: brackets_balanced?()
  belongs_to :genre
  has_many :comments, dependent: :destroy
  
  def brackets_balanced?(string)
    return false if string.length < 2
    brackets_hash = {"(" => ")", "{" => "}", "[" => "]"}
    brackets = []
    string.each_char do |x|
        if brackets_hash.keys.include?(x)
            brackets.push(x, 'a')
        elsif brackets_hash.values.include?(x) && brackets_hash[brackets.last] == x
            brackets.pop
        elsif !x.strip.empty? && brackets.last == 'a'
            brackets.pop
        end
    end
    return brackets.empty?
  end
end
