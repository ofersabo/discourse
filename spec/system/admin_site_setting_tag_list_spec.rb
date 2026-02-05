# frozen_string_literal: true

RSpec.describe "Admin tag list site setting", type: :system do
  fab!(:admin)
  fab!(:tag)

  let(:settings_page) { PageObjects::Pages::AdminSiteSettings.new }

  before { sign_in(admin) }

  it "saves and persists tag selections" do
    settings_page.visit("digest_suppress_tags")

    tag_chooser = settings_page.tag_list_setting("digest_suppress_tags")
    tag_chooser.expand
    tag_chooser.search(tag.name)
    tag_chooser.select_row_by_name(tag.name)

    settings_page.save_setting("digest_suppress_tags")

    expect(settings_page).to have_tags_in_setting("digest_suppress_tags", [tag])
    expect(SiteSetting.digest_suppress_tags.split("|")).to contain_exactly(tag.name)

    page.refresh

    expect(settings_page).to have_tags_in_setting("digest_suppress_tags", [tag])
  end
end
