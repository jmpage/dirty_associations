require 'test_helper'

class DirtyAssociationsTest < ActiveSupport::TestCase
  test "setting has_many association to the same thing is not counted as a change" do
    foo = FactoryGirl.create(:foo)
    bar.foos = [ foo ]
    bar.save

    refute bar.foos_changed?
    bar.foos = [ foo ]
    refute bar.foos_changed?
  end

  test "setting has_many association adds object to changes" do
    foo = FactoryGirl.create(:foo)

    refute bar.foos_changed?
    bar.foos = [ foo ]
    assert_equal [ foo ], bar.foos
    assert bar.foos_changed?
  end

  test "setting has_many association ids adds association to changes" do
    foo = FactoryGirl.create(:foo)

    refute bar.foos_changed?

    bar.foo_ids = [ foo.id ]
    assert_equal [ foo.id ], bar.foo_ids
    assert bar.foos_changed?
  end

  test "setting has_many association ids works with non-array" do
    foo = FactoryGirl.create(:foo)

    refute bar.foos_changed?

    bar.foo_ids = foo.id
    assert_equal [ foo.id ], bar.foo_ids
    assert bar.foos_changed?
  end

  test "setting has_many association ids ignores blanks" do
    foos = bar.foos
    bar.foo_ids += [ "", nil ]
    assert_equal foos, bar.foos

    refute bar.foos_changed?
  end

  test "changes reset by save" do
    bar.foos = [ FactoryGirl.create(:foo) ]
    assert bar.foos_changed?

    bar.save
    refute bar.foos_changed?
  end

  test "has_many association appears in previous_changes after save" do
    refute bar.foos_previously_changed?

    bar.foos = [ FactoryGirl.create(:foo) ]
    refute bar.foos_previously_changed?

    bar.save
    assert bar.foos_previously_changed?

    bar.save
    refute bar.foos_previously_changed?
  end

private
  def bar
    unless @bar
      foo = FactoryGirl.create(:foo)
      @bar = FactoryGirl.create(:bar, :foo_ids => [ foo.id ])
      @bar.save
    end
    @bar
  end
end
