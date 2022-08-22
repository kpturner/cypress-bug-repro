Feature: Bug reproduction

  Scenario: readfile result should be gettable via alias
    Given we visit the homepage
    Then readfile by alias should work
