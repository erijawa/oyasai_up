require 'rails_helper'

RSpec.describe User, type: :model do

  it "名前、メールアドレス、パスワードがあれば登録できる" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end
  it "名前がなければ登録できない" do
    expect(FactoryBot.build(:user, name: "")).to_not be_valid
  end
  it "メールアドレスがなければ登録できない" do
    expect(FactoryBot.build(:user, email: "")).to_not be_valid
  end
  it "重複したメールアドレスの場合、無効である" do
    user1 = FactoryBot.create(:user,name: "taro", email: "taro@example.com")
    expect(FactoryBot.build(:user, name: "jiro", email: user1.email)).to_not be_valid
  end
  it "パスワードがなければ登録できない" do
    expect(FactoryBot.build(:user, password: "")).to_not be_valid
  end
  it "password_confirmationとpasswordが異なる場合保存できない" do
    expect(FactoryBot.build(:user,password:"password",password_confirmation: "passward")).to_not be_valid
  end
end
