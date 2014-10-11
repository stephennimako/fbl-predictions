Feature: Displaying fixtures

  Scenario: The user should only see fixtures that are in the current round of fixtures and involve a selected team
    Given There is a fixture involving one of the selected teams in the current round of fixtures
    And There is a fixture involving two of the selected teams in the current round of fixtures
    And There is a fixture involving none of the selected teams in the current round of fixtures
    And There is a fixture involving one of the selected teams in the next round of fixtures
    And There is a fixture involving two of the selected teams in the next round of fixtures
    And There is a fixture involving none of the selected teams in the next round of fixtures
    When I log in and visit the predictions page
    Then There should be 2 fixtures involving a selected team