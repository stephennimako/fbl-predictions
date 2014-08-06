Feature: Submitting predictions

  @javascript
  Scenario: The user should be able to submit a prediction
    Given There is a fixture involving one of the selected teams in the current round of fixtures
    When I log in and visit the predictions page
    And I submit a valid prediction
    Then I should see a success notification