# subl vendor/rspec/sleeping_king_studios/examples/active_model/validation_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples/active_model'
require 'sleeping_king_studios/tools/object_tools'

module RSpec::SleepingKingStudios::Examples::ActiveModel
  module ValidationExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    module ClassMethods
      def validate_numeric_comparison(property_name, options, operation)
        value_or_proc = options[operation]
        operation     = operation.to_s.downcase

        return unless value_or_proc.is_a?(Proc) || value_or_proc.is_a?(Numeric)

        gt = operation[0] == 'g'
        eq = operation[-1] == 'o'
        lt = !gt

        value_name      = (value_or_proc.is_a?(Proc) ? 'value' : value_or_proc)
        default_message = "#{gt ? 'greater' : 'less'} than"
        default_message << ' or equal to' if eq

        describe "should validate that #{property_name} is #{default_message} #{value_name}" do
          if value_or_proc.is_a?(Proc)
            let(:limit) do
              args = [self, value_or_proc]
              args.push instance unless 0 == value_or_proc.arity

              SleepingKingStudios::Tools::ObjectTools.apply *args
            end # let
          else
            let(:limit) { value_or_proc }
          end # if

          context "with #{property_name} < #{value_name}" do
            before(:each) { instance[property_name] = limit - 1 }

            if lt
              it { expect(instance).not_to have_errors.on(property_name) }
            else
              it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, "must be #{default_message} #{limit}")) }
            end # if-else
          end # context

          context "with #{property_name} == #{value_name}" do
            before(:each) { instance[property_name] = limit }

            if eq
              it { expect(instance).not_to have_errors.on(property_name) }
            else
              it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, "must be #{default_message} #{limit}")) }
            end # if-else
          end # context

          context "with #{property_name} > #{value_name}" do
            before(:each) { instance[property_name] = limit + 1 }

            if gt
              it { expect(instance).not_to have_errors.on(property_name) }
            else
              it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, "must be #{default_message} #{limit}")) }
            end # if-else
          end # context
        end # describe
      end # class method validate_numeric_comparison
    end # module

    def self.included other
      super

      other.extend ClassMethods
    end # method included

    shared_examples 'should be valid' do
      it 'should be valid' do
        expect(instance).not_to have_errors
      end # shared_examples
    end # shared_examples

    shared_examples 'should validate inclusion of' do |property_name, options = {}|
      describe "should validate inclusion of #{property_name}" do
        let(:random_string) { chars = [*'0'..'9', *'A'..'F']; Array.new(16) { chars[rand(16)] }.inject(:<<) }

        before(:each) { instance[property_name] = :"almost_certainly_not_on_the_list_but_here_is_a_random_number_just_to_be_sure_#{random_string}" }

        it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, 'is not included in the list')) }
      end # describe
    end # shared_examples

    shared_examples 'should validate numericality of' do |property_name, options = {}|
      describe "should validate the numericality of #{property_name}" do
        before(:each) { instance[property_name] = 'not a number' }

        it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, 'is not a number')) }
      end # describe

      if options.fetch(:only_integer, false)
        describe "should validate that #{property_name} is an integer" do
          before(:each) { instance[property_name] = 3.1415926535 }

          it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, 'must be an integer')) }
        end # describe
      end # if

      validate_numeric_comparison(property_name, options, :greater_than)

      validate_numeric_comparison(property_name, options, :greater_than_or_equal_to)

      validate_numeric_comparison(property_name, options, :less_than)

      validate_numeric_comparison(property_name, options, :less_than_or_equal_to)
    end # shared_examples

    shared_examples 'should validate presence of' do |property_name, options = {}|
      describe "should validate the presence of #{property_name}" do
        before(:each) { instance[property_name] = nil }

        it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, "can't be blank")) }
      end # describe
    end # shared_examples

    shared_examples 'should validate uniqueness of' do |property_name, options = {}|
      describe "should validate uniqueness of #{property_name}" do
        let(:property_value) { instance.send(property_name) }
        let(:other) do
          return super() if defined?(super())

          factory_name = instance.class.name.gsub(/(?<lowercase>[a-z])(?<uppercase>[A-Z])/, '\k<lowercase>_\k<uppercase>').downcase
          create(factory_name, property_name => property_value )
        end # let

        before(:example) { other }

        it { expect(instance).to have_errors.on(property_name).with_message(options.fetch(:message, 'is already taken')) }
      end # describe
    end # shared_examples
  end # module
end # module
