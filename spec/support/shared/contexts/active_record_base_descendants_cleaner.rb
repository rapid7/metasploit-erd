RSpec.shared_context 'ActiveRecord::Base.subclasses cleaner' do
  before(:example) do
    expect(ActiveRecord::Base.subclasses).to be_empty
  end

  after(:example) do
    if ActiveRecord.version >= Gem::Version.new("7.0.0")
      subclasses = ActiveSupport::DescendantsTracker.subclasses(ActiveRecord::Base)
      ActiveSupport::DescendantsTracker.clear(subclasses)
    else
      cv = ActiveSupport::DescendantsTracker.class_variable_get(:@@direct_descendants)
      cv.delete(ActiveRecord::Base)
      ActiveSupport::DescendantsTracker.class_variable_set(:@@direct_descendants, cv)
    end
  end
end
