require 'fileutils'
require 'builder'

class Nonlatin
  # execute ~/config
  def initialize
    @dir = '.config/fontconfig/'
    @file = @dir + 'fonts.conf'
    @builder = Builder::XmlMarkup.new indent: 2
  end

  def output
    FileUtils.mkdir_p @dir
    File.open(@file, 'w') do |f|
      f.puts build
    end
    File.chmod(0644, @file)
  end

  private

  def build
    @builder.instruct! :xml, version: '1.0'
    @builder.declare! :DOCTYPE, :fontconfig, :SYSTEM, 'fonts.dtd'
    @builder.fontconfig do |b|
      fonts = { serif: 'TakaoPMincho', 'sans-serif': 'TakaoPGothic', monospace: 'TakaoGothic' }
      fonts.each do |k, v|
        b.alias do |a|
          a.family k.to_s
          a.prefer do |p|
            p.family v.to_s
          end
        end
      end
    end
  end
end

Nonlatin.new.output
