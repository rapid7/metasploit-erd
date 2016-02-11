RSpec.shared_context 'ActiveRecord::Base.descendants cleaner' do
  before(:example) do
    expect(ActiveRecord::Base.direct_descendants).to be_empty
  end

  after(:example) do
    # `ActiveSupport::DescendantsTracker.clear` will not clear ActiveRecord::Base subclasses because
    # ActiveSupport::Dependencies is loaded
    ActiveRecord::Base.direct_descendants.clear
  end
end