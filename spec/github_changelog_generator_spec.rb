# frozen_string_literal: true
require 'byebug'

RSpec.describe GitHubChangelogGenerator::ChangelogGenerator do
  describe "#run" do
    let(:arguments) { [] }
    let(:instance)  { described_class.new(arguments) }
    let(:output_path) { File.join(__dir__, "tmp", "test.output") }

    after { FileUtils.rm_rf(output_path) }

    let(:generator) { instance_double(::GitHubChangelogGenerator::Generator) }

    before do
      allow(instance).to receive(:generator) { generator }
      allow(generator).to receive(:compound_changelog) { "content" }
    end

    context "when full path given as the --output argument" do
      let(:arguments) { ["--output", output_path]  }
      it "puts the complete output path to STDOUT" do
        expect { instance.run }.to output(Regexp.new(output_path)).to_stdout
      end
    end

    context "when empty value given as the --output argument" do
      let(:arguments) { ["--output", ""] }
      it "puts the complete output path to STDOUT" do
        expect { instance.run }.to output(/content/).to_stdout
      end
    end

    context "when date format is given in argument" do
      let(:arguments) { ["--date-format", "%YYYY-%m-%d"] }
      it "calls generator with the given date format" do
        expect(instance.get_options[:date_format]).to eq("%YYYY-%m-%d")
      end
    end

    context "when date format is not given in argument" do
      it "calls generator with the default date format" do
        expect(instance.get_options[:date_format]).to eq("%Y-%m-%d")
      end
    end

    # context "when invalid date format is given in argument" do
    #   let(:arguments) { ["--date-format", "invalid"] }
    #   it "raises an error" do
    #     expect { instance.run }.to raise_error(ArgumentError, /invalid date format/)
    #   end
    # end

    context "when header label is given in argument" do
      let(:arguments) { ["--header-label", "Header Label"] }
      it "calls generator with the given header label" do
        expect(instance.get_options[:header]).to eq("Header Label")
      end
    end

    context "when header label is not given in argument" do
      it "calls generator with the default header label" do
        expect(instance.get_options[:header]).to eq("# Changelog")
      end
    end

    context "when no issues is specified" do
      let(:arguments) { ["--no-issues", ""] }
      it "calls generator with the no issues option" do
        expect(instance.get_options[:issues]).to eq(false)
      end
    end
  end
end
