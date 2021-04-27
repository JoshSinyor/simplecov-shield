# frozen_string_literal: true

require 'spec_helper'

describe SimpleCov::Formatter::ShieldFormatter do
  before do
    @formatter = SimpleCov::Formatter::ShieldFormatter.new

    allow(@formatter).to receive(:generate_shield)
    allow(@formatter).to receive(:coverage_percent).and_return(95)
  end

  describe '#format' do
    it 'should store the result' do
      expect(@formatter.instance_variable_get('@result')).to eq(@result)
    end

    it 'should generate the shield' do
      expect(@formatter).to receive(:generate_shield)
      @formatter.format(@result)
    end
  end

  describe '#generate_shield' do
    before do
      allow(@formatter).to receive(:generate_shield).and_call_original
    end

    after(:each) do
      @formatter.generate_shield
    end

    it 'should open the shield file' do
      expect(File).to receive(:open)
        .with("#{COVERAGE_PATH}/coverage.svg", 'w')
    end

    it 'should call shields.io api' do
      response = double(HTTParty::Response)
      allow(response).to receive(:parsed_response)

      expect(HTTParty).to receive(:get)
        .with('http://img.shields.io/badge/coverage-95%25-brightgreen.svg')
        .and_return(response)
    end

    it 'should write the shield to the file' do
      shield = File.read("#{ASSETS_PATH}/coverage_95%_brightgreen.svg")
      expect_any_instance_of(File).to receive(:write).with(shield)
    end
  end

  describe '#shield_url' do
    after(:each) do
      expect(@formatter.shield_url).to eq @url
    end

    it 'should generate a green shield url' do
      allow(@formatter).to receive(:coverage_percent).and_return(95)
      @url = 'http://img.shields.io/badge/coverage-95%25-brightgreen.svg'
    end

    it 'should generate a yellow shield url' do
      allow(@formatter).to receive(:coverage_percent).and_return(85)
      @url = 'http://img.shields.io/badge/coverage-85%25-yellow.svg'
    end

    it 'should generate a red shield url' do
      allow(@formatter).to receive(:coverage_percent).and_return(75)
      @url = 'http://img.shields.io/badge/coverage-75%25-red.svg'
    end

    it 'should append flat style option when set' do
      allow(@formatter).to receive(:coverage_percent).and_return(95)
      SimpleCov::Formatter::ShieldFormatter.config[:style] = 'flat'
      @url = 'http://img.shields.io/badge/coverage-95%25-brightgreen.svg?style=flat'
    end

    it 'should not append invalid styles' do
      allow(@formatter).to receive(:coverage_percent).and_return(95)
      SimpleCov::Formatter::ShieldFormatter.config[:style] = 'fake'
      @url = 'http://img.shields.io/badge/coverage-95%25-brightgreen.svg'
    end
  end

  describe '#coverage_percent' do
    before do
      allow(@formatter).to receive(:coverage_percent).and_call_original

      @result = double(SimpleCov::Result)
      allow(@result).to receive(:covered_percent).and_return(97.3258)

      @formatter.format(@result)
    end

    it 'should generate coverage percent' do
      expect(@formatter.coverage_percent).to eq(97)
    end

    it 'should generate coverage with configured precision' do
      SimpleCov::Formatter::ShieldFormatter.config[:precision] = 2
      expect(@formatter.coverage_percent).to eq(97.33)
    end
  end

  describe '#config' do
    it 'should return config' do
      formatter = SimpleCov::Formatter::ShieldFormatter

      expect(formatter.config).to eq(formatter.instance_variable_get('@config'))
    end
  end
end
