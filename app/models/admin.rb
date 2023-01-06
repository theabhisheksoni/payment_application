class Admin < User
  has_many :merchants, foreign_key: 'admin_id', class_name: 'Merchant', dependent: :destroy
end
