require 'spec_helper'

describe JobList do
  describe "#parse_jobs" do

    context "When empty string is given" do
      subject { described_class.new "" }

      it "returns empty sequence" do
        expect(subject.parse_jobs).to be_empty
      end
    end
  end
end
