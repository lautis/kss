require 'test/helper'

class ParserTest < Kss::Test

  def setup
    @scss_parsed = Kss::Parser.new('test/fixtures/scss')
    @sass_parsed = Kss::Parser.new('test/fixtures/sass')
    @css_parsed = Kss::Parser.new('test/fixtures/css')
    @less_parsed = Kss::Parser.new('test/fixtures/less')
    @all = Kss::Parser.new('test/fixtures')

    @css_comment = <<comment
/*
A button suitable for giving stars to someone.

.star-given - A highlight indicating you've already given a star.
.disabled   - Dims the button to indicate it cannot be used.

Styleguide 2.2.1.
*/
comment

  @starred_css_comment = <<comment
/* A button suitable for giving stars to someone.
 *
 * .star-given - A highlight indicating you've already given a star.
 * .disabled   - Dims the button to indicate it cannot be used.
 *
 * Styleguide 2.2.1. */
comment

  @slashed_css_comment = <<comment
// A button suitable for giving stars to someone.
//
// .star-given - A highlight indicating you've already given a star.
// .disabled   - Dims the button to indicate it cannot be used.
//
// Styleguide 2.2.1.
comment

  @indented_css_comment = <<comment
  /*
  A button suitable for giving stars to someone.

  .star-given - A highlight indicating you've already given a star.
  .disabled   - Dims the button to indicate it cannot be used.

  Styleguide 2.2.1.
  */
comment

  @cleaned_css_comment = <<comment
A button suitable for giving stars to someone.

.star-given - A highlight indicating you've already given a star.
.disabled   - Dims the button to indicate it cannot be used.

Styleguide 2.2.1.
comment
  @cleaned_css_comment.rstrip!

  end

  test "parses KSS comments in SCSS" do
    assert_equal 'Your standard form button.',
      @scss_parsed.section('2.1.1').description
  end

  test "parsers KSS comments in LESS" do
    assert_equal 'Your standard form button.',
      @less_parsed.section('2.1.1').description
  end

  test "parses KSS multi-line comments in SASS (/* ... */)" do
    assert_equal 'Your standard form button.',
      @sass_parsed.section('2.1.1').description
  end

  test "parses KSS single-line comments in SASS (// ... )" do
    assert_equal 'A button suitable for giving stars to someone.',
      @sass_parsed.section('2.2.1').description
  end

  test "parses KSS comments in CSS" do
    assert_equal 'Your standard form button.',
      @css_parsed.section('2.1.1').description
  end

  test "parses nested SCSS documents" do
    assert_equal "Your standard form element.", @scss_parsed.section('3.0.0').description
    assert_equal "Your standard text input box.", @scss_parsed.section('3.0.1').description
  end

  test "parses nested LESS documents" do
    assert_equal "Your standard form element.", @less_parsed.section('3.0.0').description
    assert_equal "Your standard text input box.", @less_parsed.section('3.0.1').description
  end

  test "parses nested SASS documents" do
    assert_equal "Your standard form element.", @sass_parsed.section('3.0.0').description
    assert_equal "Your standard text input box.", @sass_parsed.section('3.0.1').description
  end

  test "handles paths in file names" do
    assert_equal "less/mixins.less", @all.section('4.0.0').filename
  end

  test "public sections returns hash of sections" do
    assert_equal 2, @css_parsed.sections.count
  end

end
