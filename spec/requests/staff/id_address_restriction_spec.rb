require "rails_helper"

describe "IPアドレスによるアクセス制限" do
  before do
    Rails.application.config.baukis2[:restrict_ip_addresses] = true
  end

  it "許可" do
    AllowedSource.create!(namespace: "staff", ip_address: "127.0.0.1")
    get staff_root_url
    expect(response.status).to eq(200)
  end

  it "拒否" do
    get staff_root_url
    expect(response.status).to eq(403)
  end
end