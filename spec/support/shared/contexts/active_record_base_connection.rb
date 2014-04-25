shared_context 'ActiveRecord::Base connection' do
  before(:each) do
    ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: ':memory:'
    )
  end

  after(:each) do
    ActiveRecord::Base.connection.disconnect!
  end
end