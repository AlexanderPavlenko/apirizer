class ArticleDecorator < Apirizer::Decorator

  def brief_fieldset(json)
    json.(model, :title)
  end

  def default_fieldset(json)
    json.(model, :title, :content)
  end
end
