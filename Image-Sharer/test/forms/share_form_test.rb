require 'test_helper'

class ShareFormTest < ActiveSupport::TestCase
  def test_form_validates_presence_of_email
    form = ShareForm.new(email: 'first.last@example.com', message: 'Message')

    assert_predicate form, :valid?
    assert_equal [], form.errors[:email]
    assert_equal [], form.errors[:message]
  end

  def test_form_validates_absence_of_email
    form = ShareForm.new(email: nil)

    refute_predicate form, :valid?
    assert_equal ["Email can't be blank", 'Invalid Email format'], form.errors[:email]
  end

  def test_image_validates_format_of_email
    form = ShareForm.new(email: 'first.last', message: nil)
    refute_predicate form, :valid?

    form.email = 'first.last@example'
    refute_predicate form, :valid?
  end
end
