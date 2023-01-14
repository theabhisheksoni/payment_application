class Admin < User
  has_many :merchants, class_name: 'Merchant', dependent: :destroy
end
