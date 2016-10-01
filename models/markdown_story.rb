class MarkdownStory

  attr_reader :project, :name, :description, :labels, :tasks

  def initialize(project_id, markdown_block="")
    @project = PivotalTracker::Project.find(project_id)
    @name = "Taco"
    @description = ""
    @labels = []
    @tasks = []
    parse_block markdown_block
  end

  def upload
    story = project.stories.create(
      name:         name,
      description:  description,
      labels:       labels.join(", ")
    )
    tasks.each { |task| story.tasks.create(description: task) }
  end

  def self.parse(markdown_file)
    story_blocks = File.read(markdown_file).split(/^(?=[#])/)

    project_id = if story_blocks.first.start_with? "Project:"
      story_blocks.shift.match(/\d+/).to_s
    else
      ENV["DEFAULT_PROJECT"]
    end

    story_blocks.map { |block| MarkdownStory.new(project_id, block) }
  end

  private

  attr_writer :name, :description, :labels, :tasks

  def parse_block(markdown_block)
    markdown_block.each_line do |line|
      case line
      when /^# /      then @name = line.chomp.gsub("# ", "")
      when /^Tags: /  then @labels = line.chomp.gsub("Tags: ", "").split(', ')
      when /^- /      then @tasks << line.chomp.gsub("- ", "")
      else @description << line
      end
    end
    description.strip!
  end

end
