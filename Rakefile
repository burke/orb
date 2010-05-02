

task :doc do 
  gensym="_orb_doc_#{rand(10000)}"
  current_branch = `git branch -l | grep '*' | awk '{print $2}'`.chomp
  rubyfiles = `find lib -name '*.rb' | xargs`.chomp
  `rocco -o ../#{gensym} #{rubyfiles}`
  htmlfiles = `find ../#{gensym} -name '*.html' | xargs`.chomp
  `mv #{htmlfiles} ../#{gensym}`
  `rm -r ../#{gensym}/lib`
  `git checkout gh-pages`
  `rm -r doc` 
  `mv ../#{gensym} doc`
  `git add .; git commit -a -m "Updated rocco docs"`
  `git checkout #{current_branch}`
end 
