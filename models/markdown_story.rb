class MarkdownStory

  def initialize(project_id, markdown_block="")
    @name, @description, @labels, @tasks = "", "", [], []
    @project = PivotalTracker::Project.find(project_id)
    parse_block markdown_block
  end

  def upload
    story = project.stories.create(
      name:         name,
      story_type:   story_type,
      description:  description,
      labels:       labels.join(", ")
    )
    tasks.each { |task| story.tasks.create(description: task) }
  end

  def self.parse(markdown_text)
    story_blocks = markdown_text.split(/^(?=[#])/)

    project_id = if story_blocks.first.start_with? "Project:"
      story_blocks.shift.match(/\d+/).to_s
    else
      ENV["DEFAULT_PROJECT"]
    end

    story_blocks.map { |block| MarkdownStory.new(project_id, block) }
  end

  def self.parse_file(markdown_file)
    parse File.read(markdown_file)
  end

  private

  attr_accessor :project, :name, :story_type, :description, :labels, :tasks

  def parse_block(markdown_block)
    markdown_block.each_line do |line|
      case line
      when /^# /
        @name = line.chomp.gsub("# ", "")
        @story_type = parse_name
      when /^Labels: /
        @labels = line.chomp.gsub("Labels: ", "").split(', ')
      when /^- /
        @tasks << line.chomp.gsub("- ", "")
      else
        @description << line
      end
    end
    description.strip!
  end

  def parse_name
    case name
    when /\(feature\)$/, /\(chore\)$/, /\(bug\)$/
      name.slice!(/ \(.+\)$/).gsub(" (", "").gsub(")", "")
    else
      "feature"
    end
  end

end
