def touch filename
  puts "touch #{filename}"
  File.write filename, ""
end

def rm arg
  if arg.instance_of? Array
    arg.each do |file|
      puts "rm #{file}"
      delete_if_exists file
    end
  else
    puts "rm #{arg}"
    delete_if_exists arg
  end
end

def delete_if_exists filename
  File.delete filename if File.exists? filename
end

