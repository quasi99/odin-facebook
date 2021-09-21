require "application_system_test_case"

class CommnetsTest < ApplicationSystemTestCase
  setup do
    @commnet = commnets(:one)
  end

  test "visiting the index" do
    visit commnets_url
    assert_selector "h1", text: "Commnets"
  end

  test "creating a Commnet" do
    visit commnets_url
    click_on "New Commnet"

    click_on "Create Commnet"

    assert_text "Commnet was successfully created"
    click_on "Back"
  end

  test "updating a Commnet" do
    visit commnets_url
    click_on "Edit", match: :first

    click_on "Update Commnet"

    assert_text "Commnet was successfully updated"
    click_on "Back"
  end

  test "destroying a Commnet" do
    visit commnets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Commnet was successfully destroyed"
  end
end
