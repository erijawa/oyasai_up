require "rails_helper"

RSpec.describe Bookmark, type: :model do
  context "全てのフィールドが有効な場合" do
    it "有効であること" do
      bookmark = build(:bookmark)
      expect(bookmark).to be_valid
    end
  end

  context "ユーザーと掲示板の組み合わせがユニークでない場合" do
    it "無効であること" do
      bookmark = create(:bookmark)
      new_bookmark = build(:bookmark, user: bookmark.user, post: bookmark.post)
      new_bookmark.valid?
      expect(new_bookmark.errors[:user_id]).to include("はすでに存在します"), "bookmarkとuserのユニークバリデーションが設定されていません"
    end
  end
end
