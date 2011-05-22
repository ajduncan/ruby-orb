#!/usr/bin/ruby -w

require 'find'

class Scanner
  def initialize(dir, log)
    @start_directory = dir
    @backdoor = '<?php /**/eval('
    @logfile = File.open(log, "r+")
  end

public

  def scan()
    Find.find(@start_directory) do |path|
      if FileTest.directory?(path)
        next
      end

      if File.extname(File.basename(path)) == ".php"
        scanFile(path)
        File.chmod(0444, path)
      end
    end
  end

private

  def scanFile(path)
    if FileTest.file?(path)
      file = File.open(path, "r")
      lines = file.readlines
      lines.each_with_index do |line,index|
        if line.include?(@backdoor)
          @logfile.puts 'Backdoor found in ' + path + ' at line ' + index.to_s()
#          removeEval(path)
          @logfile.puts "Backdoor removed.\n"
        end
        if line.include?('eval(')
          @logfile.puts 'Possible backdor found in ' + path + ' at line ' + index.to_s()
        end
      end
    end
  end

  def removeEval(path)
    file = File.open(path, "r")
    lines = file.readlines
    lines.each_with_index do |line,index|
      if line.include?(@backdoor)
        lines.delete_at(index)
      end
    end
    file = File.open(path, "r+")
    file.pos = 0                     
    file.print lines
    file.truncate(file.pos)
    file.close
  end

end

scanner = Scanner.new('/path/to/scan/', '/path/to/report.txt')
scanner.scan()
