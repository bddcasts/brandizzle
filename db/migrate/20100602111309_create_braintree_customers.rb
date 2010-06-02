class CreateBraintreeCustomers < ActiveRecord::Migration
  def self.up
    Account.all.each do |account|
      return unless account.customer_id.blank?

      result = Braintree::Customer.create(:email => account.holder.email)

      if result.success?
        account.update_attribute(:customer_id, result.customer.id)
        account.update_attribute(:plan_id, Plan.standard.id)
      end
    end
  end

  def self.down
  end
end
