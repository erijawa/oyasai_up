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
              "Please suggest a recipe that substitutes #{former_ingredient_name} with #{new_ingredient_name} from the following ingredients.
              # Ingredients
              #{former_ingredients}

              # conditions for output
              - Please answer in Japanese.
              - Output should be JSON object and less than 300 tokens
              - Is '#{new_ingredient_name}' a foodstuff? Then, follow rule2. Otherwise, follow rule1.
              rule1:
              key for output:
              - title:(values for JSON should be 「食材ではありません」)
              rule2:
              keys for output:
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
