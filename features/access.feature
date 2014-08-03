Feature: Access the predictions page

  Scenario: A user should be able to login and see the predictions page
    When I log in and visit the predictions page
    Then I should see the predictions page
