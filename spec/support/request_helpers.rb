# frozen_string_literal: true

module RequestHelpers
  def json_data(response)
    JSON.parse(response.body)
  end

  def expect_error_response(response, msg:)
    data = json_data(response)
    expect(data.fetch("status")).to eq("error")
    expect(data.fetch("message")).to eq(msg)
  end
end
