Feature: Too Long Step
  As a Business Analyst
  I want to write short steps
  so that they are attractive enough to read

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'chutney'

      linter = Chutney::ChutneyLint.new
      linter.disable_all
      linter.enable %w(TooLongStep)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Long Step
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When action is quite long so that is not very readable and people even need to scroll because it does not fit on the screen
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooLongStep - This step is too long at 118 characters
        lint.feature (3): Test.A step: action is quite long so that is not very readable and people even need to scroll because it does not fit on the screen

      """
      
  Scenario: Configurable step length
    And a file named ".chutney.yml" with:
      """
      ---
      TooLongStep:
        Enabled: true
        MaxLength: 20
      """
    And a file named "lint.feature" with: 
      """
      Feature: Test
        Scenario: A
          When the step is longer than 20 characters
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      TooLongStep - This step is too long at 37 characters
        lint.feature (3): Test.A step: the step is longer than 20 characters
      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
