module Openai
  class ApiResponseService < BaseService
    def call(former_ingredient_name, new_ingredient_name, former_ingredients)
      body = build_body(former_ingredient_name, new_ingredient_name, former_ingredients)
      response = post_request(url: "/v1/chat/completions", body: body)
      extract_message_content(response)
    end

    private

    def build_body(former_ingredient_name, new_ingredient_name, former_ingredients)
      {
        model: @model,
        messages: [
          { role: "system", content: "You are professional chef." },
          { role: "user",
            content:
              "1.When a word '#{new_ingredient_name}' is invalid, your response should be '999'.

              # Invalid Cases:(Return '999')
              - a word '#{new_ingredient_name}' is not a foodstuff
              - a word '#{new_ingredient_name}' is meaningless words or phrases

              2.When a word '#{new_ingredient_name}' is valid, please provide a recipe with the following conditions.

              # a recipe to refer to
              Ingredients:
                #{former_ingredients}

              # conditions
              Ingredients: replace #{former_ingredient_name} with #{new_ingredient_name}
              Plese answer in Japanese.
              Output should be JSON object and less than 300 tokens

              # keys for output
              - title
              - ingredients:(no more than 6, format: keys for JSON should be ingredient_name and values for JSON should be quantity)
              - steps:(less than 8 steps, format: keys for JSON should be step_number and values for JSON should be instruction)
              - tips:(values for JSON should be tips for cooking)"
          }
        ],
        response_format: { "type": "json_object" }
      }.to_json
    end

    def extract_message_content(response)
      response_hash = JSON.parse(response.body)
      content = response_hash.dig("choices", 0, "message", "content")
      raise StandardError, "レシピの情報が取得できませんでした。" unless content.present?

      content
    rescue JSON::ParserError
      raise StandardError, "レシピの情報が取得できませんでした。"
    end
  end
end
