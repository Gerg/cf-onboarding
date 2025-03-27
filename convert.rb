#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

labs = [
  'onboarding_lite_labs_app_metrics.prolific',
  'onboarding_lite_labs_log_store.prolific',
  'onboarding_lite_labs_metric_store.prolific'
]

local = [
  'introduction_local.prolific',
  'deploy_local.prolific',
  'app_development_local.prolific',
  'routing_deep_dive.prolific',
  'services_redis_cups.prolific',
  'authorization.prolific',
  'networking_monitoring.prolific',
  'concourse.prolific',
  'opsman.prolific',
  'kubernetes.prolific',
  'projects.prolific',
  'onboarding_lite_labs_app_metrics.prolific',
  'onboarding_lite_labs_log_store.prolific',
  'onboarding_lite_labs_metric_store.prolific'
]

oss = [
  'introduction.prolific',
  'deploy_oss.prolific',
  'app_development.prolific',
  'feedback.prolific',
  'routing_deep_dive.prolific',
  'services_redis_cups.prolific',
  'networking_monitoring.prolific',
  'bosh_troubleshooting.prolific',
  'concourse.prolific',
  'opsman.prolific',
  'kubernetes.prolific',
  'projects.prolific',
  'clean_up.prolific'
]

nav = {
  'main' => [
    {
      'title' => 'Local',
      'url' => '/local/introduction_local/how_to_enjoy_your_first_onboarding_tracker_backlog'
    },
    {
      'title' => 'OSS',
      'url' => '/oss/introduction/welcome_to_onboarding_week_'
    },
    {
      'title' => 'Labs',
      'url' => '/labs/onboarding_lite_labs_app_metrics/lab__bug_with_______in_org_name'
    }
  ],
  'home' => [
    {
      'title' => 'Local',
      'url' => '/local/introduction_local/how_to_enjoy_your_first_onboarding_tracker_backlog'
    },
    {
      'title' => 'OSS',
      'url' => '/oss/introduction/welcome_to_onboarding_week_'
    },
    {
      'title' => 'Labs',
      'url' => '/labs/onboarding_lite_labs_app_metrics/lab__bug_with_______in_org_name'
    },
    {
      'title' => 'Additional Resources',
      'children' => [
        {
          'title' => 'Boxes and Lines',
          'url' => '/boxes_and_lines'
        },
        {
          'title' => 'Experiments',
          'url' => '/experiments'
        },
        {
          'title' => 'Facilitating',
          'url' => '/facilitating'
        },
        {
          'title' => 'FAQ',
          'url' => '/faq'
        },
        {
          'title' => 'Kick-Off Meeting',
          'url' => '/kick_off_meeting'
        },
        {
          'title' => 'New Hello Email',
          'url' => '/new_hello_email'
        },
        {
          'title' => 'Prep Checklist',
          'url' => '/prep_checklist'
        },
        {
          'title' => 'So I Heard You Like Onboarding',
          'url' => '/so_i_heard_you_like_onboarding'
        },
        {
          'title' => 'Tracks',
          'url' => '/tracks'
        },
        {
          'title' => 'Troubleshooting',
          'url' => '/troubleshooting'
        },
        {
          'title' => 'Why Facilitate',
          'url' => '/why_facilitate'
        },
        {
          'title' => 'Workstation Imaging',
          'url' => '/workstation_imaging'
        },
        {
          'title' => 'Workstation Tools',
          'url' => '/workstation_tools'
        },
      ]
    }
  ],
  'labs' => [],
  'local' => [],
  'oss' => []
}

def add_track_file(track:, topic:, filename:, title:, route:, include_path:)
  string_safe_title = title.gsub('"', '\"')
  FileUtils.mkdir_p "pages/#{track}/#{topic}"
  File.open("pages/#{track}/#{topic}/#{filename}", 'w') do |f|
    content = <<~🥔
      ---
      title: "#{string_safe_title}"
      permalink: "#{route}"
      sidebar:
        title: "#{string_safe_title}"
        nav: "#{track}"
      ---
      {% include #{include_path} %}
    🥔
    f.write(content)
  end
end

Dir.glob('*.prolific').each do |fname|
  puts "fname: #{fname}"
  topic = fname.split('.')[0]
  puts "topic: #{topic}"

  FileUtils.mkdir_p "_includes/content/#{topic}"
  prolific_file = File.open(fname, 'r')
  content = prolific_file.read
  stories = content.split("\n---\n\n")

  topic_title = topic.gsub('_', ' ')
  puts "topic title: #{topic_title}"
  labs_children = []
  local_children = []
  oss_children = []
  nav['labs'].append({ 'title' => topic_title, 'children' => labs_children }) if labs.include? fname
  nav['local'].append({ 'title' => topic_title, 'children' => local_children })  if local.include? fname
  nav['oss'].append({ 'title' => topic_title, 'children' => oss_children }) if oss.include? fname

  puts "stories: #{stories.length}"
  stories.each do |s|
    lines = s.split("\n")
    puts "lines: #{lines.length}"
    title = lines[0]
    puts "title: #{title}"
    next if title.start_with? '[RELEASE]'

    file_safe_title = title.downcase.gsub(/[^0-9A-Za-z]/, '_')
    filename = "#{file_safe_title}.md"
    puts "filename: #{filename}"

    include_story_path = "content/#{topic}/#{filename}"
    File.open("_includes/#{include_story_path}", 'w') do |f|
      f.write(lines.slice(1..).reject { |l| l.start_with?('L:') }.join("\n"))
    end
    
    if labs.include? fname
      route = "/labs/#{topic}/#{file_safe_title}"
      add_track_file(track: 'labs', topic: topic, filename: filename, title: title, route: route, include_path: include_story_path)
      labs_children.append({ 'title' => title, 'url' => route })
    end

    if local.include? fname
      route = "/local/#{topic}/#{file_safe_title}"
      add_track_file(track: 'local', topic: topic, filename: filename, title: title, route: route, include_path: include_story_path)
      local_children.append({ 'title' => title, 'url' => route })
    end

    if oss.include? fname
      route = "/oss/#{topic}/#{file_safe_title}"
      add_track_file(track: 'oss', topic: topic, filename: filename, title: title, route: route, include_path: include_story_path)
      oss_children.append({ 'title' => title, 'url' => route })
    end
  end
end

puts nav.to_yaml

FileUtils.mkdir_p '_data'
File.open('_data/navigation.yaml', 'w') do |f|
  f.write(nav.to_yaml)
end
