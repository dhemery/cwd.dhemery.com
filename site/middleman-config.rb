$middleman.set :markdown, fenced_code_blocks: true, smartypants: true, use_coderay: true

$middleman.set :haml, { ugly: true }

$middleman.activate :syntax

$middleman.activate :directory_indexes
