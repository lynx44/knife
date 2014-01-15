require 'test/unit'
require 'chef/run_list'
require 'chef/run_list/run_list_item'
require 'rspec/mocks/standalone'
require_relative('../../libraries/run_list_helper')

class TestRunListHelper < Test::Unit::TestCase
  include KnifeCookbook::RunListHelper

  def setup
    RSpec::Mocks::setup(self)
  end

  def test_merge_run_list_flattens_chef_run_list
    expectedRecipe1 = 'recipe[emailoffers_infrastructure::sql_server]'
    expectedRecipe2 = 'recipe[emailoffers_infrastructure::vms]'
    run_list = Chef::RunList.new(Chef::RunList::RunListItem.new(expectedRecipe1), Chef::RunList::RunListItem.new(expectedRecipe2))

    assert_equal([expectedRecipe1, expectedRecipe2], merge_run_list(run_list))
  end

  def test_merge_run_list_flattens_string_array
    expectedRecipe1 = 'recipe[emailoffers_infrastructure::sql_server]'
    expectedRecipe2 = 'recipe[emailoffers_infrastructure::vms]'
    run_list = [expectedRecipe1, expectedRecipe2]

    assert_equal([expectedRecipe1, expectedRecipe2], merge_run_list(run_list))
  end

  def test_merge_run_list_flattens_multiple
    expectedRecipe1 = 'recipe[emailoffers_infrastructure::sql_server]'
    expectedRecipe2 = 'recipe[emailoffers_infrastructure::vms]'
    chef_run_list = Chef::RunList.new(Chef::RunList::RunListItem.new(expectedRecipe2), Chef::RunList::RunListItem.new(expectedRecipe1))
    run_list = [expectedRecipe1, expectedRecipe2]

    assert_equal([expectedRecipe2, expectedRecipe1, expectedRecipe1, expectedRecipe2], merge_run_list(chef_run_list, run_list))
  end

  def test_merge_run_list_flattens_array_with_single_items
    expectedRecipe1 = 'recipe[emailoffers_infrastructure::sql_server]'
    expectedRecipe2 = 'recipe[emailoffers_infrastructure::vms]'
    run_list = [expectedRecipe1, expectedRecipe2]

    assert_equal([expectedRecipe1, expectedRecipe2, expectedRecipe1, expectedRecipe1], merge_run_list(run_list, expectedRecipe1, expectedRecipe1))
  end
end
