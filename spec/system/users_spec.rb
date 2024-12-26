require "rails_helper"

RSpec.describe "Users", type: :system do
  include LoginMacros
  let!(:user) { create(:user) }
  describe "ログイン前" do
    describe "ユーザーの新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザーの新規作成が成功する" do
          visit new_user_registration_path
          fill_in "名前", with: "野菜太郎"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password", match: :first
          fill_in "パスワード（確認用）", with: "password"
          check "user_registration_check"
          click_button "登録"
          expect(page).to have_content "野菜太郎さんのページ"
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_registration_path
          fill_in "名前", with: "野菜太郎"
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password", match: :first
          fill_in "パスワード（確認用）", with: "password"
          check "user_registration_check"
          click_button "登録"
          expect(page).to have_content "メールアドレスを入力してください"
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "登録済みのメールアドレスを使用" do
        it "ユーザーの新規作成が失敗する" do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in "名前", with: "野菜太郎"
          fill_in "メールアドレス", with: existed_user.email
          fill_in "パスワード", with: "password", match: :first
          fill_in "パスワード（確認用）", with: "password"
          click_button "登録"
          expect(page).to have_content "メールアドレスはすでに存在します"
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_field "メールアドレス", with: existed_user.email
        end
      end
    end
  end

  describe "ログイン後" do
    before { login_as(user) }

    describe "ユーザー編集" do
      context "フォームの入力値が正常" do
        it "ユーザーの編集が成功する" do
          visit edit_user_path(user)
          fill_in "名前", with: "太郎"
          click_button "登録"
          expect(page).to have_content "太郎さんのページ"
          expect(current_path).to eq user_path(user)
        end
      end

      context "名前が未入力" do
        it "ユーザーの編集が失敗する" do
          visit edit_user_path(user)
          fill_in "名前", with: ""
          click_button "登録"
          expect(page).to have_content "ユーザーを更新できませんでした"
          expect(page).to have_content "名前を入力してください"
          expect(current_path).to eq edit_user_path(user)
        end
      end
    end

    describe "マイページ" do
      context "投稿を作成" do
        it "新規作成した投稿が表示される" do
          create(:post, title: "自分の投稿", user: user)
          visit user_path(user)
          expect(page).to have_content("自分の投稿")
        end
      end
    end

    describe "下書き一覧" do
      context "下書きを保存" do
        it "保存した下書きが表示される" do
          post = create(:post, title: "draft", status: 1, user: user)
          visit drafts_posts_path
          expect(page).to have_content("draft")
        end
      end
    end

    describe "ブックマーク一覧" do
      context "投稿をブックマーク" do
        # 成功と失敗が交互になってしまう
        xit "ブックマークした投稿が表示される" do
          user2 = create(:user)
          post = create(:post, title: "user2の投稿", user: user2)
          visit post_path(post)
          find(".bookmark-icon").click
          visit bookmarks_posts_path
          expect(page).to have_content("user2の投稿")
        end
      end
    end
  end
end
