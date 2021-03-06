#  Copyright 2020 ThoughtWorks, Inc.
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

require File.expand_path(File.dirname(__FILE__) + '/search_test_helper')

class CardExplorerControllerTest < ActionController::TestCase
  def setup
    login_as_admin
    ElasticSearch.delete_index
  end

  def test_cards_with_date_as_name_should_not_cause_trouble
    with_first_project do |project|
      create_card! :name => '2014-01-01', :card_type => project.card_types.first
      get :search_cards, :project_id => project.identifier, :q => '2014', :card_selector => { :context_mql => 'type is any' }
      assert_response :success
    end
  end

end
