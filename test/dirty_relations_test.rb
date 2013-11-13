require 'test_helper'

class DirtyRelationsTest < ActiveSupport::TestCase
  test "setting the monitored relations flags object as changed" do
    refute mock.monitored_relations_changed?

    mock.monitored_relations = "test"

    assert_equal "test", mock.monitored_relations
    assert mock.monitored_relations_changed?
  end

  test "setting the monitored relation ids flags object as changed" do
    refute mock.monitored_relations_changed?

    mock.monitored_relation_ids = "test"

    assert_equal "test", mock.monitored_relation_ids
    assert mock.monitored_relations_changed?
  end

  test "changed flag reset by save" do
    mock.monitored_relations = "test"

    assert mock.monitored_relations_changed?

    mock.save

    refute mock.monitored_relations_changed?
  end

  test "previous changes set to last changed flag by save" do
    refute mock.monitored_relations_previously_changed?
    mock.monitored_relations = "test"
    refute mock.monitored_relations_previously_changed?
    mock.save
    assert mock.monitored_relations_previously_changed?

    mock.save
    refute mock.monitored_relations_previously_changed?
  end

private

  def mock
    @mock ||= MockModel.new
  end

  # TODO: refactor mocks
  class MockActiveRecordBase
    include ActiveModel::Model
    include ActiveModel::Dirty

    attr_accessor :monitored_relations, :monitored_relation_ids

    def initialize
      @previously_changed = {}
    end

    def save
      @previously_changed = changes
      @changed_attributes.clear
    end
  end

  class MockModel < MockActiveRecordBase
    include DirtyRelations

    monitor_association_changes :monitored_relations
  end
end
