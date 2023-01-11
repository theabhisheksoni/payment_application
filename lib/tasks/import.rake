require 'csv'

namespace :import do
  desc 'Import admins from CSV'
  task admins: :environment do
    admins = []
    file = Rails.root.join('admins.csv')
    CSV.foreach(file, headers: true) do |row|
      admins << import_admins(row)
    end
    User.upsert_all(admins)
  end

  desc 'Import merchants from CSV'
  task merchants: :environment do
    merchants = []
    file = Rails.root.join('merchants.csv')
    CSV.foreach(file, headers: true) do |row|
      merchants << import_merchants(row)
    end
    User.upsert_all(merchants)
  end

  def import_merchants(params)
    {
      name: params['Name'],
      email: params['Email'],
      description: params['Description'],
      status: params['Status'],
      encrypted_password: encrypted_password(params['Email']),
      type: 'Merchant',
      admin_id: admin_id(params['AdminId'])
    }
  end

  def import_admins(params)
    {
      name: params['Name'],
      email: params['Email'],
      type: 'Admin',
      encrypted_password: encrypted_password(params['Email'])
    }
  end

  def encrypted_password(email)
    password = password(email)
    ::BCrypt::Password.create(password)
  end

  def password(email)
    "#{email.split('@')[0]}pass123"
  end

  def admin_id(id)
    Admin.find_by(id: id)&.id
  end
end
