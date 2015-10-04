require 'workflow_controller/version'
require 'active_support/inflector'

module WorkflowController
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Defines actions for workflow events
    # see #workflow_event
    # @param events [Array<Symbol>] event names
    def workflow_events(*events)
      events.each { |event| workflow_event(event) }
    end

    # Defines action for the workflow event
    # @param events [Symbol] event name
    def workflow_event(event)
      define_method event do
        execute_workflow_event(workflow_resource, event)
      end
    end
  end

  protected

  # @return [String] name of the resource class
  def workflow_resource_class_name
    self.class.name.split('::').last.gsub(/Controller\z/, '').singularize
  end

  # @return [#workflow_state] resource which worflow state should be changed
  def workflow_resource
    instance_variable_get("@#{workflow_resource_class_name.underscore}")
  end

  # Where to redirect after successfull workflow event
  # @param _event [Symbol] completed event
  # @return [String] URL
  def successful_workflow_event_url(_event)
    url_for([resource.class, workflow_state: resource.workflow_state])
  end

  # Where to redirect after failed workflow event
  # @param _event [Symbol] failed event
  # @return [String] URL
  def failed_workflow_event_url(_event)
    url_for([resource.class, workflow_state: resource.workflow_state])
  end

  # @return [String] controller name in I18n format
  # @example
  #   Admin::PostsControllew.new.send(:workflow_i18n_prefix)
  #   # => 'admin.posts'
  def workflow_i18n_prefix
    self.class.name.underscore.gsub(/_controller\z/, '').split('/').join('.')
  end

  # Notice message for successful workflow event
  # @param event [Symbol] completed event
  # @return [String] message
  def successful_workflow_event_message(event)
    I18n.t("#{workflow_i18n_prefix}.#{event}.success")
  end

  # Alert message for failed workflow event
  # @param event [Symbol] failed event
  # @return [String] message
  def failed_workflow_event_message(event)
    I18n.t("#{workflow_i18n_prefix}.#{event}.failed")
  end

  # Changes workflow state of the resource by sending an event to it.
  # Then redirects to the further URL (e.g. list of these resources).
  # @param resource [#workflow_state] resource which state should be changed
  # @param event [Symbol] fired event name
  def execute_workflow_event(resource, event)
    resource.public_send("#{event}!")
    url = successful_workflow_event_url(event)
    redirect_to url, notice: successful_workflow_event_message
  rescue Workflow::NoTransitionAllowed
    url = failed_workflow_event_url(event)
    redirect_to url, alert: failed_workflow_event_message
  end
end
