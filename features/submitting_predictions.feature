Feature: Submitting predictions

  Scenario Outline: The user should be able to submit a prediction for standard fixture
    Given There is a fixture involving <selected_teams> of the selected teams in the current round of fixtures
    When I log in and visit the predictions page
    And I submit a valid <fixture_type> prediction
    Then I should see a success notification
    When I close the success notification
    Then I should not see a success notification
  Examples:
    | fixture_type | selected_teams |
    | standard     | one            |
    | bonus        | two            |

  Scenario: The user must make unique prediction
    Given There is a fixture involving one of the selected teams in the current round of fixtures
    When I log in and visit the predictions page
    And I submit the same prediction made by another user
    Then I should see a danger notification
    When I close the danger notification
    Then I should not see a danger notification