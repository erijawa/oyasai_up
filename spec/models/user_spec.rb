require "rails_helper"

RSpec.describe User, type: :model do
  it "名前、メールアドレスがあり、パスワードが6文字以上であれば有効であること" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "名前は30文字以下であること" do
    user = build(:user)
    user.name = "a" * 31
    user.valid?
    expect(user.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "名前、メールアドレス、パスワードは必須項目であること" do
    user = build(:user, name: nil, email: nil, password: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
    expect(user.errors[:name]).to include("を入力してください")
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "重複したメールアドレスの場合、無効であること" do
    user1 = create(:user)
    user2 = build(:user, email: user1.email)
    user2.valid?
    expect(user2.errors[:email]).to include("はすでに存在します")
  end
end
