require 'spec_helper'
require 'base_model'

module BaseModel
  class Model::SampleModel < Model
    attr_accessor :name, :description
  end

  RSpec.describe Model do
    describe Model::SampleModel do
      let!(:valid_attibutes) { { name: 'some name', description: 'dummy description' } }

      describe '#id' do
        it { should respond_to :id }

        it 'has some id' do
          expect(subject.id).not_to eq(nil)
        end

        it 'has unique id' do
          expect(subject.class.new.id).not_to eq(subject.class.new.id)
        end
      end

      describe '#initialize' do
        it 'initializes attributes based on passed hash' do
          sample = subject.class.new valid_attibutes
          valid_attibutes.each do |key, value|
            expect(sample.send key).to eq(value)
          end
        end
      end

      describe '#save' do
        it 'saves somewhere' do
          expect {
            subject.save
          }.to change { subject.class.count }.by(1)
        end

        it 'does not save already saved object twice' do
          subject.save
          expect {
            subject.save
          }.not_to change { subject.class.count }
        end
      end

      describe 'its class' do
        subject { Model::SampleModel }

        describe '::count' do
          it { should respond_to :count }
        end

        describe '::find' do
          it { should respond_to :find }

          it 'finds by id' do
            sample = subject.new valid_attibutes
            sample.save
            expect(subject.find sample.id).to eq(sample)
          end
        end

        describe '::destroy_all' do
          it { should respond_to :destroy_all }

          it 'destroys all' do
            3.times { subject.new(valid_attibutes).save }
            expect(count = subject.count).to be >= 3
            expect {
              subject.destroy_all
            }.to change { subject.count }.by(-count)
          end
        end

        describe '::all' do
          it { should respond_to :all }

          it 'returns all objects' do
            subject.destroy_all

            sample_ids = (1..5).map do |e|
              sample = subject.new(valid_attibutes)
              sample.save
              sample.id
            end

            expect(subject.all.count).to eq(5)
            expect(subject.all.map(&:id)).to eq(sample_ids)
          end
        end
      end
    end
  end
end

