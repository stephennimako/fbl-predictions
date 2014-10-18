Feature: display opponents predictions

  Scenario: The user should see predictions made by other users
    Given There is a fixture involving two of the selected teams in the current round of fixtures
    And There is a fixture involving one of the selected teams in the current round of fixtures
    And user 'Dave' has submitted predictions for this rounds fixtures
    And user 'Phil' has submitted predictions for this rounds fixtures
    When I log in and visit the predictions page
    Then I should see accordions for each fixture with header 'Dave'
    And I should see accordions for each fixture with header 'Phil'
    When I click on the accordions to see predictions made by 'Dave'
    Then I should see the score and goal scorers predicted by 'Dave'
    When I click on the accordions to see predictions made by 'Phil'
    Then I should see the score and goal scorers predicted by 'Phil'

