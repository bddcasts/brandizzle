module CapybaraExt
  def doc_table_diff(expected_table)
    doc = Nokogiri::HTML(page.body)
    actual_table = []
    yield doc, actual_table
    expected_table.diff!(Cucumber::Ast::Table.new(actual_table))
  end
end

World(CapybaraExt)
