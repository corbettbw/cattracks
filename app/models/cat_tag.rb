class CatTag < ApplicationRecord
  belongs_to :post
  belongs_to :cat
end
