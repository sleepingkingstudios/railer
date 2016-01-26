module RSpec
  module SleepingKingStudios
    def self.stub_env(variables)
      hsh = variables.each.with_object({}) do |(key, value), hsh|
        hsh[key] = ENV[key]
        ENV[key] = value
      end # object

      yield
    ensure
      hsh.each { |key, value| ENV[key] = value }
    end # class method
  end # module
end # module
