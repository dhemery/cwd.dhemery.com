require 'rake/clean'

merge_dir = 'source'
modules = ['diddleman', 'dhe.domain', 'dogger', 'site']

task default: :merge

desc "Clean and merge"
task fresh: [:clean, :merge]

desc "Merge all files from all modules into the source directory"
task :merge do
    mkdir_p merge_dir
    modules.each do |m|
        Dir.foreach(m) do |f|
            cp_r File.join(m, f), merge_dir unless f.start_with?('.', '_')
        end
    end
end

CLEAN.include merge_dir
