module Presenter
  def print_welcome
    # print the welcome message
    welcome = ["###################################",
               "#   Welcome to Clivia Generator   #",
               "###################################"]
    puts welcome.join("\n")
  end

  def print_score(title, headings, rows)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = rows
    table
  end
end
