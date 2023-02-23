class CreateLeaveWords < ActiveRecord::Migration[6.1]
  def change
    create_table :leave_words do |t|
      t.string :first_name, comment: "first_name"
      t.string :last_name, comment: "last_name"
      t.string :phone, comment: "手机号"
      t.string :company_name, comment: "公司名称"
      t.string :email, comment: "email"
      t.string :message, comment: "信息"
      t.timestamps
    end
  end
end
