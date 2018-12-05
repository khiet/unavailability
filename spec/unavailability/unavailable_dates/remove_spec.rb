require 'spec_helper'

RSpec.describe Unavailability::UnavailableDates::Remove do
  let(:dateable) { User.create(name: 'Paul') }

  subject do
    described_class.new(dateable, date_range.from, date_range.to)
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
        single_unavailability(dateable)
        subject.call
      end

      context 'and new date does not overlap' do
        let(:date_range) do
          double(from: Date.parse('2049-12-28'), to: Date.parse('2049-12-31'))
        end

        it 'does not update existing unavailability' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
        end
      end

      context 'and new date overlaps from past' do
        let(:date_range) do
          double(from: Date.parse('2049-12-31'), to: Date.parse('2050-01-01'))
        end

        it 'deletes the unavailability from left' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-02')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
        end
      end

      context 'and new date extends into future' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-05'))
        end

        it 'deletes the unavailability from right' do
          expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
          expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-03')
        end
      end

      context 'and new date overlaps in middle' do
        context 'and not touching left or right edges' do
          let(:date_range) do
            double(from: Date.parse('2050-01-02'), to: Date.parse('2050-01-03'))
          end

          it 'splits range' do
            expect(subject.unavailable_dates.count).to eq 2
          end

          it 'splits range' do
            expect(subject.unavailable_dates.where(from: '2050-01-01', to: '2050-01-01')).to be_present
            expect(subject.unavailable_dates.where(from: '2050-01-04', to: '2050-01-04')).to be_present
          end
        end

        context 'and touching left and right edges' do
          let(:date_range) do
            double(from: Date.parse('2050-01-01'), to: Date.parse('2050-01-04'))
          end

          it 'deletes part range' do
            expect(subject.unavailable_dates.count).to eq 0
          end
        end

        context 'and crossing left and right edges' do
          let(:date_range) do
            double(from: Date.parse('2049-12-31'), to: Date.parse('2050-01-05'))
          end

          it 'deletes entire range' do
            expect(subject.unavailable_dates.count).to eq 0
          end
        end

        context 'end touching left edge only' do
          let(:date_range) do
            double(from: Date.parse('2050-01-01'), to: Date.parse('2050-01-03'))
          end

          it 'deletes the unavailability from left' do
            expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-04')
            expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-04')
          end
        end

        context 'touching right only' do
          let(:date_range) do
            double(from: Date.parse('2050-01-02'), to: Date.parse('2050-01-04'))
          end

          it 'deletes the unavailability from right' do
            expect(subject.unavailable_dates.first.from).to eq Date.parse('2050-01-01')
            expect(subject.unavailable_dates.first.to).to eq Date.parse('2050-01-01')
          end
        end
      end
    end

    context 'when calendar has two unavailable_dates' do
      before do
        two_unavailability(dateable)
        subject.call
      end

      context 'and new date covers both unavailable_dates' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-06'))
        end

        it 'deletes date from each range' do
          expect(subject.unavailable_dates.where(from: '2050-01-01', to: '2050-01-03')).to be_present
          expect(subject.unavailable_dates.where(from: '2050-01-07', to: '2050-01-09')).to be_present
        end
      end
    end

    context 'when calendar has three unavailable_dates' do
      before do
        three_unavailability(dateable)

        subject.call
      end

      context 'and new date covers all unavailable_dates' do
        let(:date_range) do
          double(from: Date.parse('2050-01-04'), to: Date.parse('2050-01-11'))
        end

        it 'deletes middle' do
          expect(subject.unavailable_dates.count).to eq 2
        end

        it 'deletes date from other range' do
          expect(subject.unavailable_dates.where(from: '2050-01-01', to: '2050-01-03')).to be_present
          expect(subject.unavailable_dates.where(from: '2050-01-12', to: '2050-01-14')).to be_present
        end
      end
    end
  end

  def single_unavailability(dateable)
    dateable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
  end

  def two_unavailability(dateable)
    dateable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
    dateable.unavailable_dates.create(from: '2050-01-06', to: '2050-01-09')
  end

  def three_unavailability(dateable)
    dateable.unavailable_dates.create(from: '2050-01-01', to: '2050-01-04')
    dateable.unavailable_dates.create(from: '2050-01-06', to: '2050-01-09')
    dateable.unavailable_dates.create(from: '2050-01-11', to: '2050-01-14')
  end
end
