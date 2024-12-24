require "rails_helper"

RSpec.describe PostForm, type: :model do
  let!(:user) { create(:user) }

  context "レシピ無しでタイトルが存在する場合" do
    it "有効であること" do
      post_form = build(:post_form, user_id: user.id)
      expect(post_form).to be_valid
    end
  end

  context "レシピ付きでタイトル、レシピ情報が全て存在する場合" do
    it "有効であること" do
      post_form = build(:post_form, :with_recipe, user_id: user.id)
      expect(post_form).to be_valid
    end
  end

  context "レシピ付きでタイトルのみ存在し、draftとする場合" do
    it "有効であること" do
      post_form = build(:post_form, :with_recipe_draft, user_id: user.id)
      expect(post_form).to be_valid
    end
  end

  context "タイトルが存在しない場合" do
    it "無効であること" do
      post_form = build(:post_form, user_id: user.id, title: nil)
      post_form.valid?
      expect(post_form.errors[:title]).to include("を入力してください")
    end
  end

  context "タイトルが255文字以下の場合" do
    it "有効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.title = "a" * 255
      expect(post_form).to be_valid
    end
  end

  context "タイトルが256文字以上の場合" do
    it "無効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.title = "a" * 256
      post_form.valid?
      expect(post_form.errors[:title]).to include("は255文字以内で入力してください")
    end
  end

  context "内容詳細が65535文字以下の場合" do
    it "有効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.description = "a" * 65535
      expect(post_form).to be_valid
    end
  end

  context "内容詳細が65536文字以上の場合" do
    it "無効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.description = "a" * 65536
      post_form.valid?
      expect(post_form.errors[:description]).to include("は65535文字以内で入力してください")
    end
  end

  context "タグが20文字以下の場合" do
    it "有効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.tag_names = "a" * 20
      expect(post_form).to be_valid
    end
  end

  context "タグが21文字以上の場合" do
    it "無効であること" do
      post_form = build(:post_form, user_id: user.id)
      post_form.save(["a" * 21])
      expect(post_form.errors[:base]).to include("タグは20文字以内で入力してください")
    end
  end

  context "0人前の場合" do
    it "無効であること" do
      post_form = build(:post_form, :with_recipe, user_id: user.id, serving: 0)
      post_form.valid?
      expect(post_form.errors[:serving]).to include("は0より大きい値にしてください")
    end
  end

  context "材料が字数制限以上の場合" do
    it "無効であること" do
      post_form = build(:post_form, :with_recipe, user_id: user.id)
      post_form.ingredients_name = ["a" * 256]
      post_form.ingredients_quantity = ["a" * 51]
      post_form.save([])
      expect(post_form.errors[:base]).to include("材料は255文字以内で入力してください")
      expect(post_form.errors[:base]).to include("分量は50文字以内で入力してください")
    end
  end

  context "作り方が字数制限以上の場合" do
    it "無効であること" do
      post_form = build(:post_form, :with_recipe, user_id: user.id)
      post_form.steps_instruction = ["a" * 151]
      post_form.save([])
      expect(post_form.errors[:base]).to include("作り方は150文字以内で入力してください")
    end
  end
end
