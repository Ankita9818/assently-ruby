require "spec_helper"
require "assently"

RSpec.describe Assently do
  describe ".client" do
    it "returns a Assently::Client" do
      expect(Assently.client("admin", "secret")).to be_kind_of Assently::Client
    end

    it "passes arguments to the client" do
      client = Assently.client "admin", "secret"

      expect(client.username).to eq "admin"
      expect(client.password).to eq "secret"
    end
  end
end
