require 'spec_helper'

RSpec.describe Unavailability::UnavailableDates::Add do

  let(:datable) { User.create(name: 'John') }

  subject do
    described_class.new(datable, date_range.from, date_range.to)
  end

  describe '#call' do
    context 'when from is not a Date' do
      let(:date_range) do
        double(from: '2049-12-28', to: Date.parse('2049-12-31'))
      end

      it 'raises an error' do
        expect { subject.call }.to raise_error(ArgumentError, 'from has to be a Date')
      end
    end

    context 'when to is not a Date' do
      let(:date_range) do
        double(from: Date.parse('2049-12-28'), to: '2049-12-30')
      end

      it 'raises an error' do
        expect { subject.call }.to raise_error(ArgumentError, 'to has to be a Date')
      end
    end

    context 'when calendar has one unavailability' do
      before do
        single_unavailability(datable)
        subject.call
      end

      context 'and new date does not overlap' do
        let(:date_range) do
          double(from: Date.parse('2049-12-28'), to: Date.parse('2049-12-30'))
        end

        it 'adds new unavailability' do
          expect(subject.unavailable_dates.count).to eq 2
        end

        it 'adds new unavailability' do
          expect(subject.unavailable_dates.where(from: '2049-12-28', to: '2049-12-30')).to be_present
          expect(subject.unavailable_dates.where(from: '2050-01-01', to: '2050-01-04')).to be_present
        end

        context 'and has nabours' do
          let(:date_range) do
            double(from: Date.parse('2049-12-28'), to: Date.parse('2049-12-31'))
          end

          it 'merges two ranges' do
            expect(subject.unavailable_dates.count).to eq 1
          end

          it 'merges two ranges' do
            expect(subject.unavailable_dates.first.from).to eq Date.parse('2049-12-28')
            expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
          end
        end
      end

      context 'and new date overlaps from past' do
        let(:date_range) do
          double(from: Date.parse('2049-12-31'), to: Date.parse('2050-01-01'))
        end

        it 'expands the unavailability to left' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2049-12-31')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
        end
      end

      context 'and new date extends into future' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-05'))
        end

        it 'expands the unavailability to right' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-05')
        end
      end

      context 'and new date overlaps in middle' do
        let(:date_range) do
          double(from: Date.parse('2050-01-02'), to: Date.parse('2050-01-03'))
        end

        it 'does not update existing unavailability' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
        end
      end

      context 'and new date overlaps from past and extends into future' do
        let(:date_range) do
          double(from: Date.parse('2049-12-31'), to: Date.parse('2050-01-05'))
        end

        it 'expands to left and right' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2049-12-31')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-05')
        end
      end
    end

    context 'when calendar has two unavailable_dates' do
      before do
        two_unavailability(datable)
        subject.call
      end

      context 'and new date covers both unavailable_dates' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-06'))
        end

        it 'merges two ranges' do
          expect(subject.unavailable_dates.count).to eq 1
        end

        it 'merges two ranges' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-09')
        end
      end
    end

    context 'when calendar has three unavailable_dates' do
      before do
        three_unavailability(datable)
        subject.call
      end

      context 'and new date covers all unavailable_dates' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-11'))
        end

        it 'merges three ranges' do
          expect(subject.unavailable_dates.count).to eq 1
        end

        it 'merges three ranges' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-14')
        end
      end
    end
  end

  def single_unavailability(datable)
    datable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
  end

  def two_unavailability(datable)
    datable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
    datable.unavailable_dates.create(from: '2050-01-06', to: '2050-01-09')
  end

  def three_unavailability(datable)
    datable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
    datable.unavailable_dates.create(from: '2050-01-06', to: '2050-01-09')
    datable.unavailable_dates.create(from: '2050-01-11', to: '2050-01-14')
  end
end
