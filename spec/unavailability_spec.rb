require 'spec_helper'

RSpec.describe Unavailability do
  it 'has a version number' do
    expect(Unavailability::VERSION).not_to be nil
  end

  describe '#available_for_date?' do
    let(:datable) { User.create(name: 'Ringo') }

    before do
      datable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')
      datable.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
    end

    context 'when date is not in the unavailable date range' do
      let(:date) { Date.parse('2050-01-06') }

      it 'returns true' do
        expect(datable.available_for_date?(date)).to eq true
      end
    end

    context 'when date is in the unavailable date range' do
      let(:date) { Date.parse('2050-01-11') }

      it 'returns false' do
        expect(datable.available_for_date?(date)).to eq false
      end
    end
  end

  describe '.available_for_date' do
    let(:datable_1) { User.create(name: 'George') }
    let(:datable_2) { User.create(name: 'John') }
    let(:datable_3) { User.create(name: 'Paul') }

    before do
      datable_1.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')
      datable_2.unavailable_dates.create(from: '2050-01-01', to: '2050-01-05')

      datable_2.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
      datable_3.unavailable_dates.create(from: '2050-01-10', to: '2050-01-15')
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-02') }

      it 'returns Paul' do
        expect(User.available_for_date(date)).to eq [datable_3]
      end
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-12') }

      it 'returns George' do
        expect(User.available_for_date(date)).to eq [datable_1]
      end
    end

    context 'when date is 2050-01-02' do
      let(:date) { Date.parse('2050-01-12') }

      it 'returns George' do
        expect(User.available_for_date(date)).to eq [datable_1]
      end
    end

    context 'when date is 2050-01-20' do
      let(:date) { Date.parse('2050-01-20') }

      it 'returns George, John and Paul' do
        expect(User.available_for_date(date)).to eq [datable_1, datable_2, datable_3]
      end
    end
  end
end
