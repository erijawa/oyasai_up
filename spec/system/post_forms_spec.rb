require "rails_helper"

RSpec.describe "PostForms", type: :system do
  include LoginMacros
  let!(:user) { create(:user) }
  let!(:post) { create(:post) }

  describe "ログイン前" do
    describe "ページ遷移の権限確認" do
      context "新規投稿ページにアクセス" do
        it "新規投稿ページへのアクセスが失敗する" do
          visit new_post_path
          expect(page).to have_content("ログインもしくはアカウント登録してください")
          expect(current_path).to eq new_user_session_path
        end
      end

      context "投稿編集ページにアクセス" do
        it "投稿編集ページへのアクセスが失敗する" do
          visit edit_post_path(post)
          expect(page).to have_content("ログインもしくはアカウント登録してください")
          expect(current_path).to eq new_user_session_path
        end
      end

      context "投稿詳細ページにアクセス" do
        it "投稿の詳細ページが表示される" do
          visit post_path(post)
          expect(page).to have_content post.title
          expect(current_path).to eq post_path(post)
        end
      end

      context "投稿一覧(カード)にアクセス" do
        it "すべての投稿が表示される" do
          post_list = create_list(:post, 3)
          visit posts_path
          expect(page).to have_content post_list[0].title
          expect(page).to have_content post_list[1].title
          expect(page).to have_content post_list[2].title
          expect(current_path).to eq posts_path
        end
      end
    end
  end

  describe "ログイン後" do
  before { login_as(user) }

    describe "おやさいReportの新規投稿" do
      context "フォームの入力値が正常" do
        it "投稿の新規作成が成功する" do
          visit new_post_path
          fill_in "タイトル", with: "レポートタイトル"
          click_button "公開する"
          expect(page).to have_content "おやさいReportを作成しました"
          expect(page).to have_content "レポートタイトル"
        end
      end

      context "タイトルが未入力" do
        it "投稿の新規作成に失敗する" do
          visit new_post_path
          click_button "公開する"
          expect(page).to have_content "おやさいReportを作成できませんでした"
          expect(current_path).to eq new_post_path
        end
      end
    end

    describe "下書き保存" do
      context "レシピ付きでタイトルのみ入力済み" do
        it "投稿の下書き保存が成功する" do
          visit new_post_path
          fill_in "タイトル", with: "draftタイトル"
          select "レシピ付き", from: "post_form[mode]"
          click_button "下書きに保存する"
          expect(page).to have_content "下書きを作成しました"
          expect(page).to have_content "draftタイトル"
          expect(page).to have_content "下書き"
        end
      end

      context "タイトルが未入力" do
        it "投稿の下書き保存に失敗する" do
          visit new_post_path
          click_button "下書きに保存する"
          expect(page).to have_content "おやさいReportを作成できませんでした"
          expect(current_path).to eq new_post_path
        end
      end
    end

    describe "投稿削除" do
      it "投稿の削除が成功する" do
        post = create(:post, user: user, title: "削除予定投稿")
        visit post_path(post)
        click_on "削除"
        page.accept_confirm "本当に削除しますか?"
        expect(page).to have_content("おやさいReportを削除しました")
        expect(current_path).to eq posts_path
      end
    end
  end
end
