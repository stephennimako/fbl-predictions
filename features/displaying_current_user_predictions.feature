Feature: display current users predictions

  Scenario Outline: The user should see predictions they have made for displayed fixtures
    Given There is a fixture involving <number_of_selected_team> of the selected teams in the current round of fixtures
    And I have saved my prediction for the fixture
    When I log in and visit the predictions page
    Then I should see my prediction
  Examples:
    | number_of_selected_team |
    | one                     |
    | two                     |

