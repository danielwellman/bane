module LaunchableRoleTests

  # Verify the contract required for Launcher

  def test_responds_to_start
    assert_respond_to(@object, :start)
  end

  def test_responds_to_stop
    assert_respond_to(@object, :stop)
  end

  def test_responds_to_join
    assert_respond_to(@object, :join)
  end

  def test_responds_to_stdlog
    assert_respond_to(@object, :stdlog=)
  end
end