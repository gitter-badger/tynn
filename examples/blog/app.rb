require "ostruct"
require "redcarpet"
require "tynn"
require "tynn/hmote"
require "yaml"

articles = []

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

files = Dir[File.expand_path("articles/*.md", __dir__)]
files.each do |file|
  data, content = File.read(file).split("\n\n", 2)

  article = OpenStruct.new(YAML.load(data))

  article.content = markdown.render(content)
  article.slug = File.basename(file, ".md")

  articles << article
end

Tynn.helpers(Tynn::HMote, views: File.expand_path("views", __dir__))

Tynn.define do
  get do
    render("home", articles: articles)
  end

  on(:slug) do |slug|
    article = articles.find { |a| a.slug == slug }

    on(article.nil?) do
      res.status = 404
    end

    get do
      render("article", article: article)
    end
  end
end
