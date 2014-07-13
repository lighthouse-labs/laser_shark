require 'spec_helper'

def stub_github_with_files(files)
  github = double('github')
  github.stub_chain(:new, :gists, :get).and_return(double(files: files))
  stub_const("Github", github)
end

describe ActivityGist do
  describe "#activity_content" do
    it "should retrieve the README.md if it exists" do
      files = {
        'README.md' => double(content: "Happy happy joy joy!")
      }
      stub_github_with_files(files)
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.activity_content.should eq "Happy happy joy joy!"
    end

    it "should retrieve the README.md if it exists" do
      files = {
        'README.md' => double(content: "Contents of README.md"),
        'example.rb'  => double(content: "Contents of example.rb"),
        'notes.md'  => double(content: "Contents of notes.md")
      }
      stub_github_with_files(files)
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.activity_content.should eq "Contents of README.md"
    end

    it "should retrieve the first md file if there is no README.md" do
      files = {
        'hello.md' => double(content: "Contents of hello.md"),
        'example.rb'  => double(content: "Contents of example.rb"),
        'notes.md'  => double(content: "Contents of notes.md")
      }
      stub_github_with_files(files)
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.activity_content.should eq "Contents of hello.md"
    end

    it "should return nil if there are no markdown files" do
      files = {
        'example.rb' => double(content: "Contents of example.rb")
      }
      stub_github_with_files(files)
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.activity_content.should be_nil
    end
  end

  describe "#files_with_extension" do
    it "should find a file for a given extension" do
      files = {
        'hello.md' => double(content: "Contents of hello.md"),
        'example.rb'  => double(content: "Contents of example.rb"),
        'notes.md'  => double(content: "Contents of notes.md")
      }
      stub_github_with_files(files)
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      md_files = gist.files_with_extension('md')
      md_files.length.should eq 2
      md_files.map(&:content).should eql ["Contents of hello.md", "Contents of notes.md"]
    end
  end

  describe "internal methods" do
    before :each do
      stub_const("Github", double('github').as_null_object) # we are not hitting the API
    end

    it "should keep track of the gist url" do
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.url.should eq "https://gist.github.com/monicao/d372716cdfbb7e9cf692"
    end

    it "should extract the gist id from a gist url" do
      gist = ActivityGist.new("https://gist.github.com/monicao/d372716cdfbb7e9cf692")
      gist.send(:gist_id).should eq "d372716cdfbb7e9cf692"
    end
  end
end
