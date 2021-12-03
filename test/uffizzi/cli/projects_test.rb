# frozen_string_literal: true

require 'test_helper'

class ProjectsTest < Minitest::Test
  def setup
    @cli = Uffizzi::CLI.new

    sign_in
  end
  
  def test_projects_success
    body = json_fixture('files/uffizzi/uffizzi_projects_success.json')
    stubbed_uffizzi_projects = stub_uffizzi_projects(Uffizzi.configuration.hostname, 200, body, {})

    buffer = StringIO.new
    $stdout = buffer

    result = @cli.projects

    $stdout = STDOUT
    
    assert_equal(result, body[:projects])
    assert_requested(stubbed_uffizzi_projects)
  end

  def test_projects_unauthorized
    body = json_fixture('files/uffizzi/uffizzi_projects_failed.json')
    stubbed_uffizzi_projects = stub_uffizzi_projects(Uffizzi.configuration.hostname, 401, body, {})

    error = assert_raises(StandardError) do
      @cli.projects
    end

    assert_match(error.message, "Not authorized")
    assert_requested(stubbed_uffizzi_projects)
  end
end
