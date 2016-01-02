require 'fileutils'
require 'builder'

class NoEmbeddedBitmaps
  OUTPUT = 'build/'
  def initialize
    @dir = OUTPUT + 'etc/fonts/conf.avail/'
    @file = @dir + '71-no-embedded-bitmaps.conf'
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
      b.match target: 'font' do |m|
        m.edit mode: 'assign', name: 'embeddedbitmap' do |e|
          e.bool false
        end
        m.edit mode: 'assign', name: 'hintstyle' do |e|
          e.const 'hintnone'
        end
      end
    end
  end
end

NoEmbeddedBitmaps.new.output
