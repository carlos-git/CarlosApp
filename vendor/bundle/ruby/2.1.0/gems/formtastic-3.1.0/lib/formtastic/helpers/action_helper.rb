# -*- coding: utf-8 -*-
module Formtastic
  module Helpers
    module ActionHelper
      ACTION_CLASS_DEPRECATION = 'configure Formtastic::FormBuilder.action_class_finder instead'.freeze
      private_constant(:ACTION_CLASS_DEPRECATION)

      # Renders an action for the form (such as a subit/reset button, or a cancel link).
      #
      # Each action is wrapped in an `<li class="action">` tag with other classes added based on the
      # type of action being rendered, and is intended to be rendered inside a {#buttons}
      # block which wraps the button in a `fieldset` and `ol`.
      #
      # The textual value of the label can be changed from the default through the `:label`
      # argument or through i18n.
      #
      # If using i18n, you'll need to provide the following translations:
      #
      #   en:
      #     formtastic:
      #       actions:
      #         create: "Create new %{model}"
      #         update: "Save %{model}"
      #         cancel: "Cancel"
      #         reset: "Reset form"
      #         submit: "Submit"
      #
      # For forms with an object present, the `update` key will be used if calling `persisted?` on
      # the object returns true (saving changes to a record), otherwise the `create` key will be
      # used. The `submit` key is used as a fallback when there is no object or we cannot determine
      # if `create` or `update` is appropriate.
      #
      # @example Basic usage
      #   # form
      #   <%= semantic_form_for @post do |f| %>
      #     ...
      #     <%= f.actions do %>
      #       <%= f.action :submit %>
      #       <%= f.action :reset %>
      #       <%= f.action :cancel %>
      #     <% end %>
      #   <% end %>
      #
      #   # output
      #   <form ...>
      #     ...
      #     <fieldset class="buttons">
      #       <ol>
      #         <li class="action input_action">
      #           <input name="commit" type="submit" value="Create Post">
      #         </li>
      #         <li class="action input_action">
      #           <input name="commit" type="reset" value="Reset Post">
      #         </li>
      #         <li class="action link_action">
      #           <a href="/posts">Cancel Post</a>
      #         </li>
      #       </ol>
      #     </fieldset>
      #   </form>
      #
      # @example Set the value through the `:label` option
      #   <%= f.action :submit, :label => "Go" %>
      #
      # @example Pass HTML attributes down to the tag inside the wrapper
      #   <%= f.action :submit, :button_html => { :class => 'pretty', :accesskey => 'g', :disable_with => "Wait..." } %>
      #
      # @example Pass HTML attributes down to the `<li>` wrapper
      #   <%= f.action :submit, :wrapper_html => { :class => 'special', :id => 'whatever' } %>
      #
      # @option *args :label [String, Symbol]
      #   Override the label text with a String or a symbold for an i18n translation key
      #
      # @option *args :button_html [Hash]
      #   Override or add to the HTML attributes to be passed down to the `<input>` tag
      #
      # @option *args :wrapper_html [Hash]
      #   Override or add to the HTML attributes to be passed down to the wrapping `<li>` tag
      #
      # @todo document i18n keys
      def action(method, options = {})
        options = options.dup # Allow options to be shared without being tainted by Formtastic
        options[:as] ||= default_action_type(method, options)

        klass = action_class(options[:as])

        klass.new(self, template, @object, @object_name, method, options).to_html
      end

      protected

      def default_action_type(method, options = {}) #:nodoc:
        case method
          when :submit then :input
          when :reset  then :input
          when :cancel then :link
          else method
        end
      end

      # Takes the `:as` option and attempts to return the corresponding action
      # class. In the case of `:as => :awesome` it will first attempt to find a
      # top level `AwesomeAction` class (to allow the application to subclass
      # and modify to suit), falling back to `Formtastic::Actions::AwesomeAction`.
      #
      # Custom action namespaces to look into can be configured via the
      # .action_namespaces +FormBuilder+ configuration setting.
      # See +Formtastic::Helpers::InputHelper#namespaced_input_class+ for details.
      #
      def namespaced_action_class(as)
        @action_class_finder ||= action_class_finder.new(self)
        @action_class_finder.find(as)
      rescue Formtastic::ActionClassFinder::NotFoundError => e
        raise Formtastic::UnknownActionError, "Unable to find action #{e.message}"
      end

      # @api private
      # @deprecated Use {#namespaced_action_class} instead.
      def action_class(as)
        return namespaced_action_class(as) if action_class_finder

        action_class_deprecation_warning(__method__)

        @input_classes_cache ||= {}
        @input_classes_cache[as] ||= begin
          begin
            begin
              custom_action_class_name(as).constantize
            rescue NameError
              standard_action_class_name(as).constantize
            end
          rescue NameError
            raise Formtastic::UnknownActionError, "Unable to find action #{as}"
          end
        end
      end

      # @api private
      # @deprecated Use {Formtastic::ActionClassFinder#class_name} instead.
      # :as => :button # => ButtonAction
      def custom_action_class_name(as)
        action_class_deprecation_warning(__method__)
        "#{as.to_s.camelize}Action"
      end

      # @api private
      # @deprecated Use {Formtastic::ActionClassFinder#class_name} instead.
      # :as => :button # => Formtastic::Actions::ButtonAction
      def standard_action_class_name(as)
        action_class_deprecation_warning(__method__)
        "Formtastic::Actions::#{as.to_s.camelize}Action"
      end

      private

      def action_class_deprecation_warning(method)
        @action_class_deprecation_warned ||=
            Formtastic.deprecation.deprecation_warning(method, ACTION_CLASS_DEPRECATION, caller(2))
      end
    end
  end
end
