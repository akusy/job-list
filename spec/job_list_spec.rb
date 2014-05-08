require 'spec_helper'

describe JobList do
  describe "#parse_jobs" do

    context "When empty string is given" do
      subject { described_class.new "" }

      it "returns empty sequence" do
        expect(subject.parse_jobs).to be_empty
      end
    end

    context "When jobs depend on themselves" do
      let(:structure) { "a => \n b => c \n c => f \n d => d \n e => \n f => g" }
      subject { described_class.new structure }

      it "raises DependencyError" do
        expect { subject.parse_jobs }.to raise_error(JobList::DependencyError) 
      end
    end

    context "When jobs have circular dependecies" do
      let(:structure) { "a => \n b => c \n c => f \n d => a \n e => \n f => b" }
      subject { described_class.new structure }

      it "raises DependencyError" do
        expect { subject.parse_jobs }.to raise_error(JobList::CircularDependencyError) 
      end
    end

    describe "Correct structure is given" do
      let(:structure) { "a => \n b => c \n c => f \n d => a \n e => \n f => g" }
      subject { described_class.new structure }

      it "returns correct sequence" do
        expect(subject.parse_jobs).to eq "adgfcbe"
      end

      context "When jobs have not depedency" do
        let(:structure) { "a => \n b => \n c => \n b => \n d =>" }
        subject { described_class.new structure }

        it "removes duplicates" do
          expect(subject.parse_jobs).to eq "abcd"
        end
      end

      context "When structure contains duplicates of jobs" do
        let(:structure) { "a => d \n b => c \n c => a \n b => a \n b => d" }
        subject { described_class.new structure }

        it "removes duplicates" do
          expect(subject.parse_jobs).to eq "dacb"
          expect(subject.parse_jobs.length).to eq 4
        end
      end
    end
  end
end
