require 'spec_helper'

describe 'Articles' do
  describe 'GET /articles' do

    before :all do
      Article.delete_all
      Article.create! title: 'test', content: 'content'
    end

    it 'renders index with default fieldset' do
      get articles_path
      response.status.should == 200
      # protector should nullify :content field
      response.body.should == "{\"articles\":[{\"title\":\"test\",\"content\":null}]}"
    end

    it 'renders index with chosen fieldset' do
      get articles_path(fs: 'brief')
      response.status.should == 200
      response.body.should == "{\"articles\":[{\"title\":\"test\"}]}"
    end
  end

  describe 'POST /articles' do

    it 'allows to create only interesting articles' do
      post articles_path(article: {title: 'bla-bla', content: 'doh'})
      response.status.should == 422
      response.body.should == "{\"base\":[\"Access denied to 'content'\"]}"

      post articles_path(article: {title: 'bla-bla', content: 'very interesting'})
      response.status.should == 201
      response.body.should == "{\"article\":{\"title\":\"bla-bla\",\"content\":null}}"
      response.header['Location'].should =~ Regexp.new('/articles/\d+\Z')
    end
  end

  describe "PUT /articles/:id" do

    let(:article) { Article.create! }

    it 'allows to update some fields' do
      put article_path(article, article: {title: 'new'})
      response.status.should == 204
      response.body.should be_blank
      article.reload.title.should == 'new'

      # protector silently rejects data if field is not allowed for update
      put article_path(article, article: {content: 'new'})
      response.status.should == 204
      response.body.should be_blank
      article.reload.content.should be_nil
    end
  end

  describe "DELETE /articles/:id" do

    let(:article) { Article.create! }

    it 'does not allow to destroy record' do
      delete article_path(article)
      response.status.should == 405
      response.body.should be_blank
    end
  end
end
