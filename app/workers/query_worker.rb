class QueryWorker
  include Sidekiq::Worker

  def perform(input, revised_input, output)
    Query.create!(input: input, revised_input: revised_input, output: output.as_json)
  end
end
