guard :shell, :all_on_start => true do
  # Source map support in `guard-coffeescript` is broken.
  watch(%r{(Makefile|(.+)\.(coffee|html|svg))$}) do |m|
    `make`
  end

  # verify manifest.json (and any other JSON files)
  watch(%r{(.+)\.json$}) { |m| `cat #{m[0]} | json_verify; if [[ $? != 0 ]] ; then echo 'failed: #{m[0]}' ; fi;` }

  # generate HTML from ReST
  watch(%r{(.+)\.rst$}) { |m| `rst2html2 #{m[0]} #{m[1]}.html && echo 'ReST -> HTML finished.'` }
end
