class MarkdownStory

  attr_reader :title, :description, :tags, :tasks

  def initialize(project, markdown_block="")
    @project = project
    @title = ""
    @description = ""
    @tags = []
    @tasks = []
    parse_block markdown_block
  end

  def self.parse(markdown_file)
    story_blocks = File.read(markdown_file).split(/^(?=[#])/)

    project = if story_blocks.first.start_with? "Project:"
      story_blocks.shift.match(/\d+/).to_s
    else
      ENV["DEFAULT_PROJECT"]
    end

    story_blocks.map { |block| MarkdownStory.new(project, block) }
  end

  private

  attr_writer :title, :description, :tags, :tasks

  def parse_block(markdown_block)
    markdown_block.each_line do |line|
      case line
      when /^# /      then title = line.chomp.gsub("# ", "")
      when /^Tags: /  then tags = line.chomp.gsub("Tags: ", "").split(', ')
      when /^- /      then tasks << line.chomp.gsub("- ", "")
      else description << line
      end
    end
    description.strip!
  end

end
