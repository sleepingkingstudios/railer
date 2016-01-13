# subl vendor/rspec/sleeping_king_studios/examples/active_model/validation_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples/action_controller'
require 'sleeping_king_studios/tools/object_tools'

module RSpec::SleepingKingStudios::Examples::ActionController
  module ResponseExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should respond with' do |status, proc = nil|
      status_code = case status
      when Symbol
        Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      when String
        status.to_i
      else
        status
      end # case

      it "should respond with #{status_code.to_s} #{Rack::Utils::HTTP_STATUS_CODES[status_code]}" do
        perform_action

        expect(response.status).to be == status_code

        SleepingKingStudios::Tools::ObjectTools.apply(self, proc) if proc.is_a?(Proc)
      end # if
    end # shared_examples
  end # module
end # module
