require 'spec_helper'

class Post
  include Workflow

  workflow do
    state :draft do
      event :review, transitions_to: :on_review
    end
    state :on_review do
      event :publish, transitions_to: :published
    end
    state :published
  end
end

class PostsController
  attr_accessor :post

  include WorkflowController
  workflow_events :review, :publish
  workflow_event :close
end

describe WorkflowController do
  let(:controller) { PostsController.new }

  it 'has a version number' do
    expect(WorkflowController::VERSION).not_to be nil
  end

  describe '.workflow_event' do
    it 'adds new action' do
      expect(controller).to respond_to(:close)
    end
  end

  describe '.workflow_event' do
    it 'adds few action at once' do
      expect(controller).to respond_to(:review)
      expect(controller).to respond_to(:publish)
    end
  end

  describe '#workflow_resource_class_name' do
    it 'returns Post' do
      expect(controller.send(:workflow_resource_class_name)).to eq('Post')
    end
  end

  describe '#workflow_resource' do
    let(:post) { Post.new }

    before { controller.post = post }

    it 'returns post' do
      expect(controller.send(:workflow_resource)).to eq(post)
    end
  end
end
