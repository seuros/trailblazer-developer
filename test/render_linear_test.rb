# frozen_string_literal: true
require "test_helper"

class RenderLinearTest < Minitest::Spec
  class Create < Trailblazer::Activity::Railway
    step :decide!
    pass :wasnt_ok!
    pass :was_ok!
    fail :return_true!
    fail :return_false!
    step :finalize!
  end

  it do
    assert_equal Trailblazer::Developer::Render::Linear.(Create), %{[>decide!,>>wasnt_ok!,>>was_ok!,<<return_true!,<<return_false!,>finalize!]}
  end

  it "is aliased to `Developer.railway`" do
    assert_equal Trailblazer::Developer::Render::Linear.(Create), Trailblazer::Developer.railway(Create)
  end

  it do
    assert_equal Trailblazer::Developer::Render::Linear.(Create, style: :rows), %{
 1 ==============================>decide!
 2 ===========================>>wasnt_ok!
 3 =============================>>was_ok!
 4 <<return_true!========================
 5 <<return_false!=======================
 6 ============================>finalize!}
  end

  describe "step with only one {:success} output" do
    class Present < Trailblazer::Activity::Railway
      pass Subprocess(Trailblazer::Activity::Path), id: :ok!
    end

    it do
      assert_equal Trailblazer::Developer::Render::Linear.(Present), %{[>>ok!]}
    end
  end
end
