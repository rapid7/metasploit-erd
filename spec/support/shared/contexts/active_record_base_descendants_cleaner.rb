RSpec.shared_context 'ActiveRecord::Base.descendants cleaner' do
  before(:example) do
    expect(ActiveRecord::Base.direct_descendants).to be_empty
  end

  after(:example) do
    # `ActiveSupport::DescendantsTracker.clear` will not clear ActiveRecord::Base subclasses because
    # ActiveSupport::Dependencies is loaded
    if ActiveRecord.version >= Gem::Version.new("6.0.0.rc1")
      cv = ActiveSupport::DescendantsTracker.class_variable_get(:@@direct_descendants)
      cv.delete(ActiveRecord::Base)
      ActiveSupport::DescendantsTracker.class_variable_set(:@@direct_descendants, cv)
    else
      ActiveRecord::Base.direct_descendants.clear
    end
  end
end
