require 'test_helper'

class DirtyAssociationsTest < ActiveSupport::TestCase
  test "setting has_many association to the same thing is not counted as a change" do
    bar.foos = bar.foos.to_a
    refute bar.foos_changed?
  end

  test "adding an object by setting has_many association records changes" do
    old_foos = bar.foos.to_a
    foo = FactoryGirl.create(:foo)

    bar.foos = old_foos + [ foo ]
    assert_equal old_foos + [ foo ], bar.foos.to_a
    assert bar.foos_changed?
  end

  test "removing an object by setting has_many association records changes" do
    bar.foos = [ ]
    assert_empty bar.foos.to_a
    assert bar.foos_changed?
  end

  test "adding an object by setting has_many association via nested attributes records changes" do
    old_foos = bar.foos.to_a
    bar.foos_attributes = [ { } ]
    assert_equal old_foos.size + 1, bar.foos.size
    assert bar.foos_changed?
  end

  test "setting has_many association ids adds association to changes" do
    foo = FactoryGirl.create(:foo)

    bar.foo_ids = [ foo.id ]
    assert_equal [ foo.id ], bar.foo_ids
    assert bar.foos_changed?
  end

  test "setting has_many association ids works with non-array" do
    foo = FactoryGirl.create(:foo)

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
      refute bar.foos_changed?
    end
    @bar
  end
end
