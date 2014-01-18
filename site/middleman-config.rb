$middleman.set :markdown_engine, :redcarpet
$middleman.set :markdown, fenced_code_blocks: true, smartypants: true
$middleman.set :haml, { ugly: true }

$middleman.activate :syntax, line_numbers: true

$middleman.activate :directory_indexes
