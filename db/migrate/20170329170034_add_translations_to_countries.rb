class AddTranslationsToCountries < ActiveRecord::Migration[5.0]
  def change
    rename_column :countries, :name, :name_en
    add_column :countries, :has_confirmed_signatures, :boolean, default: false
    ['ar', 'ms', 'bn', 'bg', 'cs', 'sr', 'zh', 'de', 'es', 'el', 'fa', 'fr', 'he', 'hi',
     'hr', 'is', 'it', 'ja', 'ko', 'lv', 'hu', 'nl', 'pl', 'pt', 'ro', 'ru', 'fi', 'sv',
     'th', 'vi', 'tr'].each do |locale|
      add_column :countries, "name_#{locale}", :string
      add_index :countries, "name_#{locale}"
    end
    add_index :countries, :name_en
  end
end
