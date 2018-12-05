require 'spec_helper'

RSpec.describe Unavailability do
  it 'has a version number' do
    expect(Unavailability::VERSION).not_to be nil
  end

  describe '#available_for_date?' do
    let(:dateable) { User.create(name: 'Ringo') }

    before do
      dateable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')
      dateable.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
    end

    context 'when date is not in the unavailable date range' do
      let(:date) { Date.parse('2050-01-06') }

      it 'returns true' do
        expect(dateable.available_for_date?(date)).to eq true
      end
    end

    context 'when date is in the unavailable date range' do
      let(:date) { Date.parse('2050-01-11') }

      it 'returns false' do
        expect(dateable.available_for_date?(date)).to eq false
      end
    end
  end

  describe '#make_available' do
    let(:dateable) { User.create(name: 'Ringo') }
    let(:from)     { Date.parse('2050-01-01') }
    let(:to)       { Date.parse('2050-01-05') }
    let(:remover)  { double(:call) }

    it 'makes date available' do
      allow(Unavailability::UnavailableDates::Remove).to receive(:new).with(dateable, from, to).and_return(remover)
      expect(remover).to receive(:call)

      dateable.make_available(from: from, to: to)
    end
  end

  describe '#make_unavailable' do
    let(:dateable) { User.create(name: 'Ringo') }
    let(:from)     { Date.parse('2050-01-01') }
    let(:to)       { Date.parse('2050-01-05') }
    let(:adder)    { double(:call) }

    it 'makes date unavailable' do
      allow(Unavailability::UnavailableDates::Add).to receive(:new).with(dateable, from, to).and_return(adder)
      expect(adder).to receive(:call)

      dateable.make_unavailable(from: from, to: to)
    end
  end

  describe '.available_for_date' do
    let(:dateable_1) { User.create(name: 'George') }
    let(:dateable_2) { User.create(name: 'John') }
    let(:dateable_3) { User.create(name: 'Paul') }

    before do
      dateable_1.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')
      dateable_2.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')

      dateable_2.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
      dateable_3.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-02') }

      it 'returns Paul' do
        expect(User.available_for_date(date)).to eq [dateable_3]
      end
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-12') }

      it 'returns George' do
        expect(User.available_for_date(date)).to eq [dateable_1]
      end
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-12') }

      it 'returns George' do
        expect(User.available_for_date(date)).to eq [dateable_1]
      end
    end

    context 'when date is 2050-01-20' do
      let(:date) { Date.parse('2050-01-20') }

      it 'returns George, John and Paul' do
        expect(User.available_for_date(date)).to eq [dateable_1, dateable_2, dateable_3]
      end
    end
  end
end
