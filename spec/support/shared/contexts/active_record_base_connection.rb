RSpec.shared_context 'ActiveRecord::Base connection' do
  before(:example) do
    ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: ':memory:'
    )
  end

  after(:example) do
    ActiveRecord::Base.connection.disconnect!
  end
end